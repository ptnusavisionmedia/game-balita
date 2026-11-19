## Modul

`packages/` — (sebutkan 1 modul, jangan campur beberapa modul dalam 1 PR)

## Perubahan apa

-

## AI-assisted

- [ ] Mayoritas kode dihasilkan/dibantu AI (Claude) — reviewer tolong cek lebih teliti bagian audio timing / hit-area / edge case input anak-anak

## Checklist

- [ ] `dart run melos run analyze` lolos
- [ ] `dart run melos run test` lolos
- [ ] Tidak ada import ke `feature_*` lain selain `core`
- [ ] Sudah dicoba di device/emulator Android low-end
- [ ] Area sentuh tombol minimal ~64dp
