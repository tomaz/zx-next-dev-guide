# ZX Spectrum Next Assembler Developer Guide

ZX Spectrum Next is the successor of the Sinclair Spectrum line from the 80-ies. With all the advanced features it truly brings Spectrum to the next millenium! On a personal note though, Next represents coming back home, to Speccy, the computer where I did my first steps into the world of programming. Steps that turned into career and a journey that still fascinates me as much as it did back then!

Built upon Z80 processor, Next inherits its rich CISC intruction set. For assembler developer, CISC architecture means a plethora of useful instructions that would typically need to be implemented manually, combining multiple instructions on RISC side. But on the downside, it's hard to remember them all and even then, instructions require variety of CPU cycles and take different amount of bytes in RAM. While Next comes bundled with great manual, it only really covers BASIC.

When I started learning Z80 assembly, I quickly desired for a booklet where all instructions would be listed with some basic information such as number of bytes, CPU cycles, effects on flags etc. This would allow me to quickly assess the difference between them and chose the optimal one for task at hand. There are various documents online providing this, but neither really scratched my itch. So I fell into frequent programmer trap of "do it myself" and set to write my own. After finding [Z80 undocumented](http://www.myquest.nl/z80undocumented/), it seemed like the perfect starting point. I updated it to be more relevant for Next developer and added many new chapters explaining different areas from the perspective of assembler developer: ULA, Layer 2, Tilemap, Sprites, Sound etc. These chapters represent my notes as I was learning those topics. The rest of the book consists of instructions lists and instructions descriptions. I did leave in existing chapter about Z80 too, I found it insightful read for Next developer too!

The book was written as introduction, however I made great effort to keep it relevant as reference as well.

See introduction section in the PDF for information on the book, its history, original authors, and more. But 

The book is available in two formats:

- [Free to download PDF file](https://github.com/tomaz/zx-next-dev-guide/tags) or
- [Printed coil bound book](https://bit.ly/zx-next-assembler-dev-guide), if you prefer to have physical copy

Note: both books are the same apart from couple small differences:

- PDF doesn't include alphabetical instructions table; mainly because it's searchable so I felt it just adds noise (it does include alphabetical list in appendix though)
- PDF uses yellow-ish background for code listings, printed book is B/W so I use gray to achieve better control of the final colour
- Email addresses are obfuscated in PDF, printed book uses proper `name@domain.nnn` notation

However, you can still build printable variant yourself from sources - in fact, LaTeX source is prepared to build it as such by default!

# Editing

This is just as suggestion to help you if you're starting with LaTeX, not a prerequisite - feel free to use whichever editor and distribution you prefer!

I use VS Code with the following LaTeX plugins for editing:

- https://github.com/AREA44/vscode-LaTeX-support
- https://github.com/James-Yu/LaTeX-Workshop.git

For compiling LaTeX, I use https://miktex.org/

# Styling guide

My main intention with this document was to have printed book, therefore PDF is styled primarily with that in mind. When editing content it's important to ensure information fits nicely. Mainly: specific topic should remain on the same even/odd page boundary as much as possible to allow user to see all relevant information with as little paging as possible. Of course larger topics will be split between multiple pages. It's fine to split individual parts from odd to even page, as both pages are visible when the book is open, but when the information is crossing from even to odd page, care should be taken. Most of the time, I opted to use small gap so the following content is available in full on next page. Sometimes I also sacrificed order (for example instructions details section) to avoid too much gap.

To help with layout, I suggest using 2 page spread mode. If you're using LaTeX Workshop plugin, you can change preview to open in this mode with this setting:

```
"latex-workshop.view.pdf.spreadMode": 2
```

# Sample code

Sample code from the book is also included in this repository. I use VS Code for programming Next as well. You can find all information on setup I use in the PDF.

# Todo / Ideas

Couple ideas for new content:

- Description for other relevant ZX Spectrum / Next port
- Add DMA chapter
- Add sample project for interrupts
- ~Split LaTeX source into multiple files, one per chapter with `include` (or `includeonly` for quicker compiling when working on individual chapters)~

# License

ZX Spectrum Next Developer Guide and companion source code are available under GNU license, please see the end of PDF document for full licence info!