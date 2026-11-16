import sys,sqlite3,json
args=json.load(sys.stdin)
c=sqlite3.connect(args['path']);c.row_factory=sqlite3.Row
try:
 if 'migration' in args:c.executescript(args['migration']);c.commit();print('{}')
 else:
  out=[]
  for q in args['queries']:
   cur=c.execute(q['sql'],q.get('values',[]));rows=[dict(r) for r in cur.fetchall()];out.append({'results':rows,'meta':{'changes':max(cur.rowcount,0)}})
  c.commit();print(json.dumps(out))
except Exception as e:
 c.rollback();print(json.dumps({'error':str(e)}));sys.exit(1)
