---
name: music-tagger
description: >
  Fix, clean up, or write audio file metadata tags (ID3, Vorbis, etc.) for use
  with Navidrome or other music servers. Trigger when the user wants to: read or
  inspect tags on audio files (MP3, FLAC, Opus, M4A, etc.), fix incorrect or
  messy metadata (titles containing artist names, missing multi-valued artist
  tags, inconsistent fields), re-tag an album or batch of files, or prepare
  files for import into Navidrome. Also trigger when the user mentions music
  tagging, ID3 tags, mutagen, MusicBrainz lookups for tag correction, or
  Navidrome tagging guidelines.
---

# Music Tagger

Fix and write audio file metadata for Navidrome compatibility.

Use `uv run --with mutagen` to run all tagging operations. Use `mutagen.id3`
(not `EasyID3`) for full control over ID3 frames, especially TXXX frames for
multi-valued tags.

## Workflow

1. **Discover files** — Glob for audio files in the target directory.
2. **Read current tags** — Print a summary table of key fields (title, artist,
   albumartist, album, tracknumber, date, genre) for all tracks.
3. **Identify issues** — Common problems:
   - Titles containing artist names (e.g. `"Artist - Song"` instead of `"Song"`)
   - Missing multi-valued ARTISTS/ALBUMARTISTS tags
   - Inconsistent artist credits across tracks
   - Missing fields (disc number, genre, date)
4. **Cross-reference** — When the user provides MusicBrainz URLs (or asks to
   look up releases/recordings), fetch them with WebFetch to verify correct
   artist credits, titles, and release info. This is especially important for
   collaborations where credit style varies (e.g. `feat.` vs `&` vs `×`).
5. **Present a tagging plan** — Show the user a table of all proposed changes
   **before writing anything**. Include track number, new title, artist display
   name, and multi-valued artists list. Wait for approval.
6. **Write tags** — Apply changes using mutagen. For MP3 (ID3v2.4):
   - `TIT2` — Title
   - `TPE1` — Artist display name (e.g. `Tinlicker feat. Nathan Nicholson`)
   - `TPE2` — Album artist
   - `TXXX:ARTISTS` — Multi-valued artist list (e.g. `["Tinlicker", "Nathan Nicholson"]`)
   - Save with `tags.save(v2_version=4)` to ensure ID3v2.4.
7. **Verify** — Read back tags from a sample of tracks (prioritize those with
   multiple artists) and print them to confirm correctness.

## Navidrome-Specific Tagging Rules

See [references/navidrome-tagging.md](references/navidrome-tagging.md) for the
full reference. Key points:

- Always set both singular ARTIST (display) and plural ARTISTS (multi-valued).
- Navidrome uses the singular tag as "Display Name" when both exist.
- For MP3, check ID3 version first (`tags.version`). ID3v2.4 supports true
  multi-valued tags. ID3v2.3 does not — prefer upgrading to v2.4.
- Multi-valued ARTISTS is stored as `TXXX:ARTISTS` in ID3.
- Recognized separators in singular ARTIST: ` / `, ` feat. `, `; `. But prefer
  explicit multi-valued tags over relying on separator parsing.

## File & Album Naming Conventions

- **Album names with years** — Put the year in parentheses:
  `Live From Coachella (2025)`, not `Live From Coachella 2025`.
- **Track file prefixes** — Use zero-padded two-digit track numbers:
  `01. Artist - Title.mp3`, not `1. Artist - Title.mp3`.
  When renaming, only pad single-digit numbers (files 10+ are already correct).

## Example: Writing Multi-Artist Tags (MP3/ID3v2.4)

```python
from mutagen.id3 import ID3, TIT2, TPE1, TXXX

tags = ID3("track.mp3")
tags.delall("TIT2")
tags.delall("TPE1")
tags.delall("TXXX:ARTISTS")

tags.add(TIT2(encoding=3, text="Be Here And Now"))
tags.add(TPE1(encoding=3, text="Tinlicker feat. Nathan Nicholson"))
tags.add(TXXX(encoding=3, desc="ARTISTS", text=["Tinlicker", "Nathan Nicholson"]))
tags.save(v2_version=4)
```

## Example: Reading Tags for Verification

```python
from mutagen.id3 import ID3

tags = ID3("track.mp3")
print(f"Title:   {tags['TIT2'].text}")
print(f"Artist:  {tags['TPE1'].text}")
print(f"AlbArt:  {tags['TPE2'].text}")
print(f"Artists: {tags['TXXX:ARTISTS'].text}")
```
