{
  description = "ola-mundo — the first blue service: one Bluefile service declaration rendered into its image, Helm chart, typed settings, schema and module trio";
  inputs.blue.url = "github:pleme-io/blue";
  outputs = { blue, ... }: blue.lib.project { src = ./.; };
}
