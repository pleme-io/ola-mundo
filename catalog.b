use("deeta", [:pretty])
use("haibi")

lock = json_read(read_file("#{getenv("GEN_ROOT", ".")}/Bluefile.lock"))
manifest = lock["manifest"]
name = "ola-mundo"
out = getenv("GEN_OUT")
mkdir_p(path_dirname(out))

write_file(
  out,
  unlines(
    [
      pretty(
        haibi::catalog_entry(
          name,
          manifest["version"],
          get(manifest["services"], name)
        )
      )
    ]
  )
)
