# SHA-256 manifest

Scripts named in `papers/gentry-m003-arithmetic-v5.tex` (Table 1 and text) and their committed logs, hashed over the committed blob contents at commit `a4c181dfd91f14bcc1600217f4a6b4a8ff467e36`.

Verify on Linux/macOS: `sha256sum -c reproduce/SHA256SUMS` (run from the repository root).  Verify anywhere: `python reproduce/make_sha256_manifest.py --verify`.  Regenerate: `python reproduce/make_sha256_manifest.py --write`.

| Script | Log(s) | SHA-256 of script |
|---|---|---|
| `reproduce/m003_J10_vs_intersection.py` | `reproduce/m003_J10_vs_intersection.log` | `1dc29326b580890536d1a07946998741ff19b3e969d49aed58ab6600f7fbbb8b` |
| `reproduce/m003_J3_strengthening_certificate.py` | `reproduce/m003_J3_strengthening_certificate.log` | `680ba9767ec131bdba948d48007bf973fc700a52e792701ba34d4dd56854a059` |
| `reproduce/m003_collision_ideal_certificate.py` | `reproduce/m003_collision_ideal_certificate.log` | `329bbb4a818767d01f1b8bb73e6db67d020e42c8ea0ac2dc3444078c680f8a2b` |
| `reproduce/m003_dehn_relator_certificate.py` | `reproduce/m003_dehn_relator_certificate.log` | `393b109d73ccce5833a5402e9d2bbdcfe1356ea6233a9b7efe5de7e908f1e259` |
| `reproduce/m003_identify_Y_minus.sage` | `reproduce/m003_identify_Y_minus.log` | `56bc03dda9700416dbea60aae4e64974bf1e3db07066b3dfed962d4e9a0bef19` |
| `reproduce/m003_m006_X0_cap_N_point_argument.py` | `reproduce/m003_m006_X0_cap_N_point_argument.log` | `92cf89159f657c1e5fac63d0e24761894061245854e6741ef394d0dc809d12fd` |
| `reproduce/m003_squared_locus_and_conjugacy.sage` | `reproduce/m003_squared_locus_and_conjugacy.log` | `3edd1a182ee842965eff4b03aec462142905ca8c798b02b07ff2fe5ad7bbc44c` |
| `reproduce/m003_stage4_x0_identity_origin.py` | `reproduce/m003_stage4_x0_identity_origin.log` | `65c46c142977c99ea642de2c281bd4c10cef06fb25877ea0450cd40410cbf964` |
| `reproduce/m003_structure_atlas.sage` | `reproduce/m003_atlas_run.log`, `reproduce/m003_atlas_manifest.json`, `reproduce/m003_filling_summary.csv`, `reproduce/m003_pair_atlas.csv`, `reproduce/m003_word_atlas.csv` | `51da04ee0d1542fecd75dc122c089eb6958a7c8ffd6f86f6662d51eb8672bf5d` |
| `reproduce/m003_surgery_law_certificate.py` | `reproduce/m003_surgery_law_certificate.log` | `82543dff61ed2464202e0d9e2216f78b077591748cd300f0a02a7efed262bab7` |
| `reproduce/m003_three_universal_identities.sage` | `reproduce/m003_three_universal_identities.log` | `8d36f7d48035d67ecccf3fd9e59d54a0f13e310f216427163e9d2cbb8925253f` |
| `reproduce/m006_J10_vs_intersection.py` | `reproduce/m006_J10_vs_intersection.log` | `0129de5e7e0bbbb0b81cf04d9cf0598c2c92409b7921aa5aaa3fa106df2d91e6` |
| `reproduce/pmns_itf_certificate.sage` | `reproduce/pmns_itf_certificate.log` | `69859ce4ecd8751dc470db7436ba60f335d55e3a692d36bc1b39b045516a4f80` |
