# ola-mundo — the golden blue service

The premier example of blue templating. A new blue service starts as a copy of this repo.
One declaration (`Bluefile`) and one program (`ola.b`) lower to every artifact; nothing is
written twice. It is the reference for the batteries-included blue service: one `service(...)`,
one `model(...)`, the handlers, and every concern a bidama (`theory/BLUE-STRUCTURE.md` §6.5–6.6,
`blue/docs/SERVICE-ARCHITECTURE.md`). Today its `schema` is the first rendering of the model.

## What it shows

| Pattern | Where |
|---|---|
| One `service(...)` declaration, no runtime named | `Bluefile` |
| Settings in tiers (defaults, file, env), unknown keys refused | `config`, `flags` in `Bluefile`; `settei` in `ola.b` |
| Schema first: the table declaration renders the migration | `schema` in `Bluefile`; `/greetings` in `ola.b` |
| SLO: latency objective, burn-rate rules and a dashboard in the chart | `slo` in `Bluefile` |
| Generated catalog entry, gated by freshness | `generate("catalog", ...)`, `deploy/catalog/ola-mundo.json` |
| Hardened image through the factory, chart on pleme-lib, release on ryn's engenho | lowered from the lock; `nix` repo `nodes/ryn/default.nix` |

## Rules for changing it

- A pattern a second service needs is proven here first, then the service adopts it.
- When blue's surface changes, bring this repo current in the same pass: `nix flake update blue`,
  `blue fmt --write`, then `nix flake check` until `checks.project` is green.
- Keep it minimal. A feature stays only if it shows a golden pattern from the table above.
- Do not add a runtime selector, a second secret type or a hand-written chart here. Placement
  belongs to the node; the declaration names only what the service needs.

## Check

`nix flake check` runs `checks.project`. `nix run .#scan-images` scans the image.
