{
  description = "ola-mundo: the first blue service, every artifact rendered from its Bluefile";
  inputs.blue.url = "github:pleme-io/blue";
  outputs = { blue, ... }: blue.lib.project { src = ./.; };
}
