+++
menutitle = "Labels"
date = 2018-12-29T17:15:52Z
weight = 1
chapter = false
pre = "<b>- </b>"
+++

# Why we need labels ?

If you have a bucket of white dominos and you need to segregate dominos with its number of dots.

Lets say we want all dominos with 10 dots, we will take domino one by one and if its having 10 dots we will put it aside and continue the same operation until all dominos were checked

Likewise , suppose if you have 100 pods and few of them are nginx and few of them are centos , how we can just display nginx pods ?

We need a label on each pod so that we can tell `kubectl` command to show the pods with that label.

In kubernetes , label is a key value pair and it provides identifying metadata for objects
These are fundamental qualities of objects that will be used for grouping , viewing and operating

For now we will se how we can view them (Will discuss about grouping and operation on pod groups later)
