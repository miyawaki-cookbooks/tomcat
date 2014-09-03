#
# Cookbook Name:: tomcat
# Attributes:: default
# 
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

default["tomcat"]["version"] = "7"
default["tomcat"]["ins_dir"] = "/usr/local"
default["tomcat"]["home"] = "/usr/local/tomcat"
default["tomcat"]["base"] = "/var/lib/tomcat"
default["tomcat"]["user"]  = "tomcat#{node["tomcat"]["version"]}"
default["tomcat"]["group"] = "tomcat#{node["tomcat"]["version"]}" 

default["tomcat"]["bin"]  = "#{node["tomcat"]["base"]}/bin"
default["tomcat"]["conf"] = "#{node["tomcat"]["base"]}/conf"
default["tomcat"]["webapp_dir"] = "#{node["tomcat"]["base"]}/webapps"
default["tomcat"]["lib"] = "#{node["tomcat"]["base"]}/lib"
default["tomcat"]["temp"] = "#{node["tomcat"]["base"]}/temp"
default["tomcat"]["work"] = "#{node["tomcat"]["base"]}/work"

default["tomcat"]["download"]["url"] =  "http://ftp.riken.jp/net/apache/tomcat/tomcat-7/v7.0.54/bin/apache-tomcat-7.0.54.tar.gz"
default["tomcat"]["download"]["checksum"] = "f0316c128881c4df384771dc0da8f8e80d861385798e57d22fd4068f48ab8724" 
