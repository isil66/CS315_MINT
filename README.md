# CS315_MINT
Fall 2023 Team_09:
- [Işıl Özgü](https://github.com/isil66/)
- [Dilara Mandıracı](https://github.com/dilaramandiraci)
- [Yusuf Toraman](https://github.com/YusufToraman)

## Integer Language Design for Computational Purposes
During this project, I learned the importance of working with people with a similar approach to things because it gets easier to start a sprint and continue. I am grateful to my teammates for that, as it was a joy to do this project alongside them.

In terms of language design, I understood the design choices made in many languages, as it was challenging to define a programming language that is both readable, writeable, and is flexible enough to allow users to create complex programs but strongly typed enough not to let developers make unnoticed mistakes. After this project, I became a Java enthusiast; I am now grown enough to appreciate all the unnecessary-looking syntax.

I can proudly say our project received the highest grade of our semester for the first part of it, 98, and we were able to make it a 100 in the second part of the project.
## Building and Running the Compiler

To compile the parser and generate the executable, use the following command:

```bash
make parser
```

This will generate an executable file named 'parser'. To test the parser, you can use the following command:

```bash
./parser < CS315_F23_Team9_X.txt
```
Replace 'X' with the test number (e.g., 1, 3, 4). Some tests include syntax errors, and you can find the problematic lines in the corresponding CS315_F23_Team9_X.txt file as line comments.

To remove generated files and the parser executable, use the following command:

```bash
make clean
```
This will delete the lex.yy.c, y.tab.c, and parser files.
