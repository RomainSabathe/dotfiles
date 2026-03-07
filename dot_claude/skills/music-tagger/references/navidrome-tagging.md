# Navidrome Tagging Reference

## Key Principles

- Navidrome organizes music entirely based on metadata tags, not file/folder names.
- Every track needs: Title, Artist, Album, Album Artist, Track Number.
- Consistency is critical: same spelling/punctuation across all tracks in an album.

## Multi-Artist Tagging (Critical)

Navidrome supports both singular and plural artist tags. **Multi-valued tags are preferred.**

### Tag Roles

| Tag | Purpose | Example |
|-----|---------|---------|
| ARTIST (TPE1) | Display name, single string | `Tinlicker feat. Nathan Nicholson` |
| ARTISTS (TXXX:ARTISTS) | Multi-valued, each artist separate | `["Tinlicker", "Nathan Nicholson"]` |
| ALBUMARTIST (TPE2) | Primary album artist | `Tinlicker` |
| ALBUMARTISTS (TXXX:ALBUMARTISTS) | Multi-valued album artists | `["Tinlicker"]` |

When both singular and plural tags exist, Navidrome uses the singular as the "Display Name".

### Format Support

| Format | Multi-valued support |
|--------|---------------------|
| FLAC/Vorbis/Opus | Native (multiple tag entries) |
| ID3v2.4 (MP3) | Native (null-separated or TXXX frames) |
| ID3v2.3 (MP3) | No. Use separators like `; ` as last resort. Prefer ID3v2.4. |
| MP4/M4A | Check editor support |

### Separators Navidrome Recognizes

In the singular ARTIST field: ` / `, ` feat. `, `; `

Avoid relying on separators — they break for names like `AC/DC` or `Earth, Wind & Fire`.

## Other Important Tags

- **Compilation**: Set `TCMP=1` (ID3) or `COMPILATION=1` (Vorbis) for VA compilations.
- **Date fields**: `DATE` (recording), `ORIGINALDATE` (original release), `RELEASEDATE` (this release). Formats: `YYYY`, `YYYY-MM-DD`, `YYYY-MM`.
- **Disc Number**: Use for multi-disc albums. Format: `1/2`.
- **Genre**: Multi-valued field.
- **Roles** (COMPOSER, LYRICIST, etc.): No plural version. Add the singular tag multiple times.

## Album Art

- Embed cover art in each file and/or place `cover.jpg`/`folder.jpg`/`front.png` in the album folder.
- 500x500 to 1000x1000 px is recommended.
