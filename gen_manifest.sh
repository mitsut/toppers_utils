#!/bin/sh
######################################################################
# 
# MANIFESTFILE generator
#
# Copyright (C) 2017-2020 by Mitsutaka Takada
#
# The above copyright holders grant permission gratis to use,
# duplicate, modify, or redistribute (hereafter called use) this
# software (including the one made by modifying this software),
# provided that the following four conditions (1) through (4) are
# satisfied.
#
# (1) When this software is used in the form of source code, the above
#     copyright notice, this use conditions, and the disclaimer shown
#     below must be retained in the source code without modification.
#
# (2) When this software is redistributed in the forms usable for the
#     development of other software, such as in library form, the above
#     copyright notice, this use conditions, and the disclaimer shown
#     below must be shown without modification in the document provided
#     with the redistributed software, such as the user manual.
#
# (3) When this software is redistributed in the forms unusable for the
#     development of other software, such as the case when the software
#     is embedded in a piece of equipment, either of the following two
#     conditions must be satisfied:
#
#   (a) The above copyright notice, this use conditions, and the
#       disclaimer shown below must be shown without modification in
#       the document provided with the redistributed software, such as
#       the user manual.
#
#   (b) How the software is to be redistributed must be reported to the
#       TOPPERS Project according to the procedure described
#       separately.
#
# (4) The above copyright holders and the TOPPERS Project are exempt
#     from responsibility for any type of damage directly or indirectly
#     caused from the use of this software and are indemnified by any
#     users or end users of this software from any and all causes of
#     action whatsoever.
#
# THIS SOFTWARE IS PROVIDED "AS IS." THE ABOVE COPYRIGHT HOLDERS AND
# THE TOPPERS PROJECT DISCLAIM ANY EXPRESS OR IMPLIED WARRANTIES,
# INCLUDING, BUT NOT LIMITED TO, ITS APPLICABILITY TO A PARTICULAR
# PURPOSE. IN NO EVENT SHALL THE ABOVE COPYRIGHT HOLDERS AND THE
# TOPPERS PROJECT BE LIABLE FOR ANY TYPE OF DAMAGE DIRECTLY OR
# INDIRECTLY CAUSED FROM THE USE OF THIS SOFTWARE.
#
######################################################################
# カレントフォルダにMANIFESTファイルを作成する
#
# gen_manifest.sh [-R]
#
# -R:再帰出力をしない
# --------------------------------------------------------------------
# $Id:  $
######################################################################

#初期パラメータの設定
RECURSIVE_FLG=1
GENERATE_FILE="MANIFEST"

PROGNAME=$(basename $0)
VERSION="1.0"

# ヘルプメッセージ
usage() {
  echo "Usage: $PROGNAME [-R]"
  echo 
  echo "Option:"
  echo "  -h, --help"
  echo "      --version"
  echo "  -R, Output files at ONLY current directory."
  exit 1
}


# オプション解析
for OPT in "$@"
do
	case "$OPT" in
	'-h'|'--help' )
		usage
		exit 1
		;;
	'--version' )
		echo $PROGNAME $VERSION
		exit 1
		;;
	'-R' )
		RECURSIVE_FLG=0
		;;
	*)
	# コマンド引数（オプション以外のパラメータ）
		if [[ ! -z "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
		param+=( "$1" )
		shift 1
		fi
		;;
	esac
done

# 以下，実行本体

#既にMANIFESTが存在する場合は既存のファイルをMANIFEST.OLDに置き換える
if [ -e $GENERATE_FILE ]; then
mv $GENERATE_FILE $GENERATE_FILE.OLD
fi
#GENERATE_FILE="MANIFEST.NEW"
#	#MANIFEST.NEWがあった場合は削除
#	if [ -e $GENERATE_FILE ]; then
#	rm -f $GENERATE_FILE
#	fi
#fi

#デフォルトの情報出力
echo "PACKAGE " >> $GENERATE_FILE
echo "VERSION \n" >> $GENERATE_FILE

#フォルダ以下のファイルのリスト表示
if test $RECURSIVE_FLG -eq 1 ;then
	find . -type f | sort >> $GENERATE_FILE
else
	ls -1 | sort >> $GENERATE_FILE
fi

#リスト結果の文字列の整形
sed -i".org" -e "s/^.\///" $GENERATE_FILE
sed -i".org" -e "/^.svn/d" $GENERATE_FILE
sed -i".org" -e "/^MANIFEST.OLD/d" $GENERATE_FILE
sed -i".org" -e "/^MANIFEST.*.bak/d" $GENERATE_FILE
sed -i".org" -e "/^.git/d" $GENERATE_FILE
rm $GENERATE_FILE.org
