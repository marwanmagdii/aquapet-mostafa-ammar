import { notFound } from "next/navigation";
import { VetDetailClient } from "@/components/VetDetailClient";
import { trustedVets } from "@/lib/vets";

export function generateStaticParams() {
  return trustedVets.map((v) => ({ id: v.id }));
}

export default async function VetDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const vet = trustedVets.find((v) => v.id === id);

  if (!vet) {
    notFound();
  }

  return <VetDetailClient vet={vet} />;
}
