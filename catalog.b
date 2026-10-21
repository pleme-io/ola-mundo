use("deeta", [:pretty])
use("haibi")

lock = json_read(read_file("#{getenv("GEN_ROOT", ".")}/Bluefile.lock"))
manifest = get(lock, "manifest")
name = "ola-mundo"
out = getenv("GEN_OUT")
mkdir_p(path_dirname(out))

write_file(
  out,
  "#{pretty(haibi::catalog_entry(name, get(manifest, "version"), get(get(manifest, "services"), name)))}\n"
)
