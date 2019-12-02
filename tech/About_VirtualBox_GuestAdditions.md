## VirtualBox-GuestAdditionsがインストールできない話
https://tutorialmore.com/questions-20598.htm

結論から言えば、ここに記載されている方法で解決した。  
VirtualBoxに内蔵してあるGuestAdditionsがおかしい或いは、OS自体に何かしらの以上がある場合には、インターネットからインストールし直せば良いだけだという話。  
※動作環境はDebian-10(buster)  

> リストの更新  
> $ apt update  
> $ apt install build-essential gcc make perl dkms  
> GuestAdditionsが配置してあるフォルダへ（大抵はcdrom）  
> $ cd /media/cdrom
> $ sh VBoxLinuxAdditions.run  
完了したのちに  
> $ reboot

再起動後、画面操作及び拡張が可能になる。  

## ホストとゲストでコピペを出来るようにする設定
参考部分は後半。前半はGuestAdditionsの自動インストールについての話。  
これが出来ないから、上記の操作を行うんだけどね。  
https://onoredekaiketsu.com/copy-and-paste-with-virtualbox/  
VirtualBox側のマネージャーを起動して、ゲストOSのページに行き設定(S)ボタンをクリック。高度のページを開き、クリップボードの共有とドラック&ペーストの項目を双方向に設定する。以上で、ホストーゲスト間コピペが出来るようになる。
