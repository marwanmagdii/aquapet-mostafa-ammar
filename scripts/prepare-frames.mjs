import fs from "node:fs";
import path from "node:path";
import sharp from "sharp";

const ROOT = process.cwd();
const srcArgIdx = process.argv.indexOf("--src");
const srcFolderName = srcArgIdx !== -1 && process.argv[srcArgIdx + 1] ? process.argv[srcArgIdx + 1] : "frames";
const SRC_DIR = path.join(ROOT, srcFolderName);
const DESKTOP_DIR = path.join(ROOT, "public", "frames");
const MOBILE_DIR = path.join(ROOT, "public", "frames-mobile");
const PUBLIC_DIR = path.join(ROOT, "public");
const MAX_DESKTOP_BYTES = 25 * 1024 * 1024; // 25 MB

const SUPPORTED_EXTS = new Set([".jpg", ".jpeg", ".png", ".webp"]);

function naturalSort(a, b) {
  return a.localeCompare(b, undefined, { numeric: true, sensitivity: "base" });
}

function formatBytes(bytes) {
  const mb = bytes / (1024 * 1024);
  return `${mb.toFixed(2)} MB (${bytes.toLocaleString()} bytes)`;
}

function ensureCleanDir(dir) {
  fs.mkdirSync(dir, { recursive: true });
  for (const entry of fs.readdirSync(dir)) {
    fs.unlinkSync(path.join(dir, entry));
  }
}

async function processLogo() {
  const srcLogo = path.join(ROOT, "logo.png");
  if (!fs.existsSync(srcLogo)) {
    console.warn("Warning: logo.png not found in project root.");
    return;
  }

  fs.mkdirSync(PUBLIC_DIR, { recursive: true });
  fs.copyFileSync(srcLogo, path.join(PUBLIC_DIR, "logo.png"));

  const meta = await sharp(srcLogo).metadata();
  await sharp(srcLogo).webp({ quality: 90 }).toFile(path.join(PUBLIC_DIR, "logo.webp"));

  // Check if corners are transparent
  const { data, info } = await sharp(srcLogo)
    .ensureAlpha()
    .raw()
    .toBuffer({ resolveWithObject: true });

  const cornerOffsets = [
    0,
    (info.width - 1) * 4,
    (info.height - 1) * info.width * 4,
    ((info.height - 1) * info.width + (info.width - 1)) * 4,
  ];
  const cornerAlphas = cornerOffsets.map((offset) => data[offset + 3]);
  const hasTransparentCorners = cornerAlphas.every((alpha) => alpha < 32);

  console.log(
    `Logo processed: ${meta.width}x${meta.height}, hasAlpha=${meta.hasAlpha}, transparentCorners=${hasTransparentCorners}`
  );
}

async function encodeSet(files, outDir, width, quality, step = 1) {
  ensureCleanDir(outDir);
  const selected = files.filter((_, idx) => idx % step === 0);
  let totalBytes = 0;
  let outputWidth = width;
  let outputHeight = 0;

  for (let i = 0; i < selected.length; i++) {
    const srcPath = path.join(SRC_DIR, selected[i]);
    const fileName = `frame_${String(i + 1).padStart(3, "0")}.webp`;
    const destPath = path.join(outDir, fileName);

    const info = await sharp(srcPath)
      .resize({ width, withoutEnlargement: true })
      .webp({ quality })
      .toFile(destPath);

    totalBytes += info.size;
    outputWidth = info.width;
    outputHeight = info.height;
  }

  return {
    count: selected.length,
    totalBytes,
    width: outputWidth,
    height: outputHeight,
    quality,
    files: selected.map((_, i) => `frame_${String(i + 1).padStart(3, "0")}.webp`),
  };
}

async function main() {
  if (!fs.existsSync(SRC_DIR)) {
    throw new Error(`Source frames directory not found: ${SRC_DIR}`);
  }

  const sourceFiles = fs
    .readdirSync(SRC_DIR)
    .filter((f) => SUPPORTED_EXTS.has(path.extname(f).toLowerCase()))
    .sort(naturalSort);

  if (sourceFiles.length === 0) {
    throw new Error(`No image frames found in ${SRC_DIR}`);
  }

  console.log(`Found ${sourceFiles.length} source frames (${sourceFiles[0]} -> ${sourceFiles[sourceFiles.length - 1]})`);

  await processLogo();

  // Desktop: 1600px wide, start at quality 92 and step down if > 25 MB
  let desktopQuality = 92;
  let desktopWidth = 1600;
  let desktopResult = await encodeSet(sourceFiles, DESKTOP_DIR, desktopWidth, desktopQuality, 1);

  while (desktopResult.totalBytes > MAX_DESKTOP_BYTES && desktopQuality > 45) {
    desktopQuality -= 10;
    console.log(
      `Desktop frames (${formatBytes(desktopResult.totalBytes)}) exceed 25 MB. Retrying at quality ${desktopQuality}...`
    );
    desktopResult = await encodeSet(sourceFiles, DESKTOP_DIR, desktopWidth, desktopQuality, 1);
  }

  if (desktopResult.totalBytes > MAX_DESKTOP_BYTES) {
    desktopWidth = 1280;
    console.log(
      `Desktop frames still exceed 25 MB. Retrying at width ${desktopWidth}px, quality ${desktopQuality}...`
    );
    desktopResult = await encodeSet(sourceFiles, DESKTOP_DIR, desktopWidth, desktopQuality, 1);
  }

  // Mobile: 800px wide, quality 70, every 2nd frame
  const mobileResult = await encodeSet(sourceFiles, MOBILE_DIR, 800, 70, 2);

  const desktopManifest = {
    count: desktopResult.count,
    width: desktopResult.width,
    height: desktopResult.height,
    quality: desktopResult.quality,
    totalBytes: desktopResult.totalBytes,
    totalMB: Number((desktopResult.totalBytes / (1024 * 1024)).toFixed(2)),
    basePath: "/frames",
    pattern: "frame_{index}.webp",
    mobile: {
      count: mobileResult.count,
      width: mobileResult.width,
      height: mobileResult.height,
      quality: mobileResult.quality,
      totalBytes: mobileResult.totalBytes,
      totalMB: Number((mobileResult.totalBytes / (1024 * 1024)).toFixed(2)),
      basePath: "/frames-mobile",
      pattern: "frame_{index}.webp",
    },
  };

  const mobileManifest = {
    count: mobileResult.count,
    width: mobileResult.width,
    height: mobileResult.height,
    quality: mobileResult.quality,
    totalBytes: mobileResult.totalBytes,
    totalMB: Number((mobileResult.totalBytes / (1024 * 1024)).toFixed(2)),
    basePath: "/frames-mobile",
    pattern: "frame_{index}.webp",
  };

  fs.writeFileSync(
    path.join(DESKTOP_DIR, "manifest.json"),
    JSON.stringify(desktopManifest, null, 2)
  );
  fs.writeFileSync(
    path.join(MOBILE_DIR, "manifest.json"),
    JSON.stringify(mobileManifest, null, 2)
  );

  console.log(`\nDesktop frames (${DESKTOP_DIR}):`);
  console.log(`  Count: ${desktopResult.count}`);
  console.log(`  Dimensions: ${desktopResult.width}x${desktopResult.height}`);
  console.log(`  Quality: ${desktopResult.quality}`);
  console.log(`  Total Size: ${formatBytes(desktopResult.totalBytes)}`);

  console.log(`\nMobile frames (${MOBILE_DIR}):`);
  console.log(`  Count: ${mobileResult.count}`);
  console.log(`  Dimensions: ${mobileResult.width}x${mobileResult.height}`);
  console.log(`  Quality: ${mobileResult.quality}`);
  console.log(`  Total Size: ${formatBytes(mobileResult.totalBytes)}`);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
