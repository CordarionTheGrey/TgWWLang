# TgWWLang

This is an unofficial script to aid maintaining translations for [Werewolf][werewolf] Telegram game
(see [@werewolftranslation][translation] channel). There is a (kind of) official XML editor —
[WuffPad][wuffpad], — but if you’re comfortable with a terminal and your favourite text editor, need
advanced features, or just don’t have Windows, you may like this one.

[werewolf]:    https://github.com/GreyWolfDev/Werewolf
[translation]: https://t.me/werewolftranslation
[wuffpad]:     https://telegra.ph/WuffPad-05-18


## Installation

0. Install [Python][python] (the latest is recommended; minimal supported versions are
   **3.2** and **2.7**).
1. Grab [`requirements.txt`][requirements] and run `pip install -Ur requirements.txt`.
2. Download [`tgwwlang.py`][tgwwlang-py] and [`tgwwlang.xsd`][tgwwlang-xsd] and put them to whatever
   directory you wish.
3. _(optional)_ Symlink `tgwwlang.py` to a place in your `PATH`.

[python]:       https://www.python.org/downloads/
[requirements]: https://raw.githubusercontent.com/CordarionTheGrey/TgWWLang/master/requirements.txt
[tgwwlang-py]:  https://raw.githubusercontent.com/CordarionTheGrey/TgWWLang/master/tgwwlang.py
[tgwwlang-xsd]: https://raw.githubusercontent.com/CordarionTheGrey/TgWWLang/master/tgwwlang.xsd


## Usage

<!-- [[[cog import tgwwlang; cog.outl("```%s```" % tgwwlang.__doc__)]]] -->
```
Usage:
    tgwwlang.py check
        [--model <langfile>]
        [--] <langfile>
    tgwwlang.py update
        [-i <indent>] [--move-comments] [--no-backup]
        [--model <langfile>] [--assign-attributes]
        [(--base <langfile> [--add-missing] [--reorder])]
        [--] <langfile>
    tgwwlang.py -h
    tgwwlang.py -V

Options:
    -h, --help           Show this message.
    -V, --version        Show version number.
    --model <langfile>   The reference langfile (English.xml).
    --base <langfile>    A langfile where additional data is taken from.
    -i, --indent <size>  Size of indentation. Prepend `-` to not indent direct
                         children of the root. Append `t` to indent with tabs.
                         [default: 2]
    --move-comments      Move external comments into `<string>` tags.
    --no-backup          Do not create `.bak` file.
    --assign-attributes  Copy `<string>` attributes from the model langfile.
    --add-missing        Copy missing strings from the base langfile.
    --reorder            Reorder strings to match the base langfile.
```
<!-- [[[end]]] (checksum: 940b77a16fd6ee81b52e6b612659e45c) -->


### Examples

*   `tgwwlang.py check Russian.xml`  
    Validate the langfile. Will run full validation cycle if there is `English.xml` nearby;
    otherwise, only syntax check and basic semantics checks are performed.

*   `tgwwlang.py update Russian.xml`  
    Reformat the langfile: indent with 2 spaces.

*   `tgwwlang.py update Russian.xml -it`  
    Reformat the langfile: indent with tabs.

*   `tgwwlang.py update Russian.xml --assign-attributes`  
    Also put `deprecated="true"` and `isgif="true"` where necessary.

*   `tgwwlang.py update RussianMafia.xml --base=Russian.xml --add-missing`  
    Copy new strings from `Russian.xml` to `RussianMafia.xml`, appending them at the end
    of the file.

*   `tgwwlang.py update RussianMafia.xml --base=Russian.xml --move-comments --reorder`  
    Rearrange strings in `RussianMafia.xml` to match `Russian.xml`’s ordering. `<!-- Comments -->`
    are moved into corresponding `<string>`s (otherwise, they’ll just stick together). Then you can
    easily run a diff checker on these two files.

*   `tgwwlang.py update RussianMafia.xml --base Russian.xml --assign-attributes --move-comments
    --add-missing --reorder -i-2`  
    Do everything and produce result in a compact format.


## Performed checks

1. Syntax validity (e.g., unclosed tags).
2. Structure validity (`<strings>` should contain a `<language />` and `<string>`s, each `<string>`
   should contain `<value>`s, etc.).
3. A langfile should be open (i.e., have no `owner`); a warning is given otherwise.
4. A language should have a unique `name`, as well as `base`+`variant` pair.
5. Correct attribute usage (`deprecated`, `isgif`, `isDefault`).
6. Each string should have a unique `key`. Exception: a langfile is allowed to have 2 strings with
   the same key iff the _2nd_ is `deprecated` and the _1st_ is not.
7. Missing strings, missing values, empty values.
8. Strings with unknown `key`s.
9. Missing and extra placeholders (`{0}` and friends). If the reference langfile is unavailable,
   placeholders are simply checked to be consistent across multiple `<value>`s of a `<string>`.
