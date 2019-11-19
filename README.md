# TgWWLang

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
        [(--base <langfile> [--reorder] [--add-missing])]
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
    --reorder            Reorder strings to match the base langfile.
    --add-missing        Copy missing strings from the base langfile.
```
<!-- [[[end]]] (checksum: c24560bbe0d07c7e18428168c279dd1d) -->


### Examples

* `tgwwlang.py check Russian.xml`  
    Validate the langfile. Will run full validation cycle if there is `English.xml` nearby;
    otherwise, only syntax check and basic semantics checks are performed.

* `tgwwlang.py update Russian.xml`  
    Reformat the langfile: indent with 2 spaces.

* `tgwwlang.py update Russian.xml -it`  
    Reformat the langfile: indent with tabs.

* `tgwwlang.py update Russian.xml --assign-attributes`  
    Also put `deprecated="true"` and `isgif="true"` where necessary.

* `tgwwlang.py update RussianMafia.xml --base=Russian.xml --add-missing`  
    Copy new strings from `Russian.xml` to `RussianMafia.xml`, appending them to the end
    of the file.

* `tgwwlang.py update RussianMafia.xml --base=Russian.xml --move-comments --reorder`  
    Rearrange strings in `RussianMafia.xml` to match `Russian.xml`’s ordering. `<!-- Comments -->`
    are moved into corresponding `<string>`s (otherwise, they’ll just stick together).

* `tgwwlang.py update RussianMafia.xml --base Russian.xml -i-2 --assign-attributes --move-comments
    --reorder --add-missing`  
    Do everything and produce result in a compact format.
