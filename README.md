tomcat Cookbook
================
tomcatをダウンロードしてインストールするCookbook。  
CATALINA\_HOMEとCATALINA\_BASEを分けて設定することを前提とし、
インストールしたCATALINA\_HOMEから、必要なファイルをCATALINA\_BASEにコピーして起動する。  
tomcatの自動起動に対応するstartup-shellを/etc/init.dに配置する。

Requirements
------------
CentOS 6.5、Oracle Linux6.5で動作確認済み。
(centosを前提としているため、互換性のある環境だけで動作するはず。ohaiの値をチェックしていない）
また、tomcat7、および、tomcat8で動作確認済み。

### 依存パッケージ  
* java

### 依存するlocal cookbook
* iptables

Attributes
----------
* `tomcat['version']`
    - tomcatのversion。
    - デフォルト値は、"7"。

* `tomcat['ins_dir']`
    - tomcatのインストール先ディレクトリ。
    - tomcatの配布tarボールを解凍先。この下にtarボール名の実ディレクトリを作成して、CATALINA_HOMEにシンボリックリンクを作成する。
    - デフォルト値は、"/usr/local"。

* `tomcat['home']`
    - CATALINA_HOME。
    - デフォルト値は、"/usr/local/tomcat"。

* `tomcat['base']`
    - CATALINA_BASE。
    - CATALINA_BASE以下のサブディレクトリは、cookbookで作成する。
    - また、CATALINA_BASE/logsは、/var/log/tomcatへのシンボリックリンクとして作成する。
    - デフォルト値は、"/var/lib/tomcat"。

* `tomcat['user']`
    - tomcatの動作するユーザ名。uidは、53固定で作成する。
    - デフォルト値は、"tomcat" + version ("tomcat7")

* `tomcat['group']`
    - tomcatの動作するグループ名。gidは、53固定で作成する。
    - デフォルト値は、"tomcat" + version ("tomcat7")


* `tomcat['download'][url]`
    - apache-tomcatのインストール用tarボール(tar.gz)の入手先URL。
    - デフォルトは、7.0.54のtarボールのURLが設定されている。
    
* `tomcat['download'][cheksum]`
    - apache-tomcatのインストール用tarボール(tar.gz)のSHA-256のチェックサム。
    - デフォルトは、7.0.54のtarボールのチェックサムが設定されている。


Usage
-----
#### tomcat::default

たとえば、rolesファイルをこんな感じで書く。nodesのjsonファイルは、git.rbを呼べばよい。

    # git.rb
	name = "gitserver"  
    
	override_attributes  
	  "iptables" =>  
	  {  
	    "tomcat" => "8080"  
	  },  
	  "java" =>  
	  { "install_flavor" => "oracle",  
	    "jdk_version"=> 7,  
	    "java_home"=> "/usr/local/java",  
	    "oracle" => { "accept_oracle_download_terms" => true }  
	  },  
	  "tomcat" =>  
	  { "7" =>  
	    { "url" => "http://ftp.yz.yamagata-u.ac.jp/pub/network/apache/tomcat/tomcat-7/v7.0.53/bin/apache-tomcat-7.0.53.tar.gz",  
	     "checksum" => "f5e79d70ca7962d11abfc753e47b68a11fdfb4a409e76e2b7bd0a945f80f87c9"  
	    }  
	  },
	  "gitbucket" =>  
	  { "url" => "https://github.com/takezoe/gitbucket/releases/download/2.0/gitbucket.war",  
	    "checksum" => "95060786c0ec898593c21995dc95ffbb89d43c2501c83ed4631b8201fa53219e",
	    "type" => "tomcat",  
	    "home" => "/var/lib/gitbucket/"  
	  }  

	run_list "recipe[iptables::iptables]",
	    "recipe[java]",
	    "recipe[tomcat]",
	    "recipe[gitbucket]"


License and Authors
-------------------
Authors:: YAMAMOTO,Miyawaki,Tamie
