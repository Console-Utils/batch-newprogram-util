# newprogram

## Description

Simple program generator for C# and PascalABC.NET.

## Requirements

Supported environments: Windows 10 and Wine 5.0.

Command line utils pre-installed:

- [sed](http://gnuwin32.sourceforge.net/packages/sed.htm)

## Syntax

```bat
newprogram [options]
```

## Options

- `-h`|`--help` - writes help and exits
- `-v`|`--version` - writes version and exits
- `-l`|`--language` - specifies language name [Available value set is: csharp, pascal.]
- `-p`|`--path` - specifies program path
- `-o`|`--options` - specifies program options with values via space

## Error codes

- `0` - Success
- `2` - Specified option is not supported.
- `2` - Specified language name must be one of: csharp, pascal.
- `2` - Specified path doesn't exist.

## Examples

```bat
newprogram --help
```

```bat
newprogram --language csharp --path "path/to/program" --options "--help --version"
```
