#!/usr/bin/env/python3
# coding: utf_8

import elasticsearch
import json

counter = 1
size = 10000

# ドキュメント毎の処理
def get_doc(hits):
 global counter
 for hit in hits:
   text = hit['_source']['message']
   print(counter, text)
   counter += 1

# Elasticsearch
es = elasticsearch.Elasticsearch("localhost:9200")

# 検索条件
response = es.search( scroll='2m', index="index名", size=size,
 body={"query": {"match_all": {}}})

sid = response['_scroll_id']
#print('sid', sid)
#print( 'total', response['hits']['total'] )

scroll_size = len( response['hits']['hits'] )
#print('scroll_size', scroll_size)

#jsonfileでの保存
fw = open("index名.json", 'w')
json.dump(response,fw,indent=4)

while True:

# スクロールサイズ 0 だったら終了
 if scroll_size <= 0:
  break

 # 検索結果を処理
 get_doc(response['hits']['hits'])

 # スクロールから次の検索結果取得
 response = es.scroll(scroll_id=sid, scroll='10m')
 scroll_size = len(response['hits']['hits'])
 #print( 'scroll_size', scroll_size)
