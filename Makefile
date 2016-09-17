# 使い方
# 	html(単一、複数)、infoを作成する場合は、make
# 	全部(pdf、txt、tarを含む)を作成する場合は、make && make pdf && make txt && make tar

# 必要なもの
#
# po4a(https://po4a.alioth.debian.org/index.php.ja)が必要です
# 理由:	翻訳前のtexiとpoファイルから翻訳済みのtexiを生成するため
#
# texinfo(https://www.gnu.org/software/texinfo/)が必要です
# 理由:	texiファイルからhtml、infoを生成するため
#
# tar(https://www.gnu.org/software/tar/)が必要です(オプション)
# 理由:		texiファイルをアーカイブするため
# コンパイル:	makeの後にmake tar
#
# texlive(http://www.tug.org/texlive/)が必要です(オプション)
# 理由:		texiファイルから日本語PDFを作成するため
# コンパイル:	makeの後にmake pdf

.PHONY: clean

# デフォルトは単一html、分割html、info
all: single-html multi-html info

# 単一html用のターゲット
single-html: emacs.html

# 分割html用のターゲット
# html/*.htmlが生成されます
multi-html: html/index.html

# info用のターゲット
info: emacs251-ja.info

# ASCII text用のターゲット
txt: emacs.txt

# pdf用のターゲット(オプション)
pdf: emacs.pdf emacs-xtra.pdf

# tar.gz用のターゲット(オプション)
tar: emacs.texis.tar.gz

TEXIS := \
abbrevs.texi \
anti.texi \
arevert-xtra.texi \
basic.texi \
buffers.texi \
building.texi \
cal-xtra.texi \
calendar.texi \
cmdargs.texi \
commands.texi \
custom.texi \
dired-xtra.texi \
dired.texi \
display.texi \
emacs-xtra.texi \
emacs.texi \
emerge-xtra.texi \
entering.texi \
files.texi \
fixit.texi \
fortran-xtra.texi \
frames.texi \
help.texi \
indent.texi \
killing.texi \
kmacro.texi \
m-x.texi \
macos.texi \
maintaining.texi \
mark.texi \
mini.texi \
misc.texi \
modes.texi \
msdos-xtra.texi \
msdos.texi \
mule.texi \
package.texi \
picture-xtra.texi \
programs.texi \
regs.texi \
rmail.texi \
screen.texi \
search.texi \
sending.texi \
text.texi \
trouble.texi \
vc-xtra.texi \
vc1-xtra.texi \
windows.texi \
xresources.texi

clean:
	rm -f *.texi
	rm -f emacs.html
	rm -fR html/
	rm -f emacs251-ja.info
	rm -f emacs.pdf
	rm -f emacs-xtra.pdf
	rm -f emacs.txt
	rm -f emacs.texis.tar.gz
	rm -fR emacs.texis/
	rm -f *.bak

%.texi:
	if [ -f $@.po ]; \
	then \
		po4a-translate -f texinfo -k 0 -M utf8 -m original_texis/$@ -p $@.po -l $@; \
	else \
		cp -pf original_texis/$@ $@; \
	fi; \

emacs.html: $(TEXIS)
	./translate_25.1.sh
	texi2any --set-customization-variable TEXI2HTML=1 emacs.texi

html/index.html: $(TEXIS)
	./translate_25.1.sh
	makeinfo -o html/ --html emacs.texi

emacs245-ja.info: $(TEXIS)
	./translate_25.1.sh
	makeinfo --no-split -o emacs245-ja.info emacs.texi

emacs.pdf emacs-xtra.pdf: $(TEXIS)
	./translate_25.1.sh
	TEX=ptex texi2dvi -c emacs.texi
	dvipdfmx emacs.dvi
	rm -f emacs.dvi

	TEX=ptex texi2dvi -c emacs-xtra.texi
	dvipdfmx emacs-xtra.dvi
	rm emacs-xtra.dvi

emacs.txt: $(TEXI)
	./translate_25.1.sh
	texi2any --plaintext emacs.texi > emacs.txt

emacs.texis.tar.gz: $(TEXIS)
	./translate_25.1.sh
	if [ ! -d emacs.texis ]; \
	then \
		mkdir emacs.texis/; \
	fi

	cp -fp *.texi emacs.texis
	tar cvfz ./emacs.texis.tar.gz ./emacs.texis
