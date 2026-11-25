import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  trailingSlash: true,
  images: {
    unoptimized: true,
  },
  async redirects() {
    return [
      {
        source: "/:path*/index.txt",
        destination: "/:path*/",
        permanent: false,
      },
    ];
  },
};

export default nextConfig;
