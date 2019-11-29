# いきなりだがLinuxはファイルの区別に拡張子を用いない
- 何のことだかさっぱりだと思うが端末(termianl)でプログラミングした人には分かるかもしれない。  
拡張子には色んな種類があることは言わなくても経験則として知っている場合が多いだろう。例えば
 - テキストファイルの[.txt]
 - シェルスクリプトの[.sh]
 - tarアーカイブの[.tar]
 - 圧縮ファイルの[.zip][.gzip]  
 
 上記に記述したもの以外にも多数存在するが、コンピュータに関わる以上は多様な拡張子を見てきただろう。しかし、linux上ではこれらの拡張子にはあんまり意味がないことをつい最近知った。必要ないのではなく、人間がせっせと.txtだの.cだの付ける必要はコンピュータ側にはなかったということだ。Linuxに初めて触れてプログラミングをしたときにvimやtouchコマンドで拡張子を付けなくてもファイルを作成出来たためWindouwsでしつこく言われた拡張子がないとダメ！っていうのはないんだなぁと漠然と感じたものだ。ファイルの中身に記述した内容をコンピュータ側が解釈してこの種類のファイルだ！と理解してくれるため、拡張子を記述するのは人間のためと考えた方が良いみたいだ。実際拡張子がついてないと何のファイルなのか分からないため、どのみち拡張子を付けてファイルを作成することは大切なのだと改めて感じた。

 > $ vim test  
 > $ ls  
 > test　←存在してる！  
 > $ file test  
 > empty　←ファイルに何も記載していなければこうなる  
 > $ vim test.txt  
 > $ file test.txt  
 > UTF-8 text-file　みたいなの出るから明示的に付けておいた方がやっぱりいいね

### 参考文献
http://yutechi.hatenablog.com/entry/2014/05/20/222528