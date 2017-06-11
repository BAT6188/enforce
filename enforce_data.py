# -*- coding: utf-8 -*-
import pymysql,datetime,random,time,threading

class PeData:
    def __init__(self,host,user,passwd,db,charset):
        self.host = host
        self.db = pymysql.connect(host=host,
                                  user=user,
                                  passwd=passwd,
                                  db=db,
                                  charset=charset)
        self.cursor = self.db.cursor()
    def get_one_emp_area(self):
        sql = """
        SELECT code,name,e.areaid,areaname,cpxh 
        FROM employee as e ,area_dep as a,pe_base as p
        WHERE empid >= (SELECT MAX(empid) FROM employee) * RAND() 
        AND a.areaid=e.areaid AND e.code = p.jybh
        """
        try:
           # 执行sql语句
           self.cursor.execute(sql)
           result = self.cursor.fetchall()
           result = random.choice(result)
           print(result)
           return result[0],result[1],result[2],result[3],result[4]
        except:
           # 如果发生错误则回滚
           print('获取警员信息发生错误')
           return False
    def get_one_ws(self):
        sql='select gzzbh,gzz_ip from ws_base'
        try:
           # 执行sql语句
           self.cursor.execute(sql)
           result = self.cursor.fetchall()
           info = random.choice(result)
           return info[0],info[1]
        except:
           # 如果发生错误则回滚
           print('获取工作站信息发生错误')
           return False       
    def getInsertInfo(self):
        code,name,areaid,areaname,cpxh = self.get_one_emp_area()
        gzzbh,gzz_ip = self.get_one_ws()
        tempeTime = time.time()-24*60*60
        tempbTime = time.time()-7*24*60*60
        start_time = random.randrange(int(tempbTime),int(tempeTime))
        wjlx = random.randrange(0,4)
        insertList = {}
        if wjlx == 1:
            wjcd = random.randrange(2*60,5*60+1)
            end_time = start_time+wjcd
            #视频结束时间
            insertList['end_time'] = time.strftime('%Y-%m-%d %H:%M:%S', time.gmtime(end_time))
            #视频时长
            insertList['wjcd'] = wjcd
        temp = start_time+random.randrange(16*60*60,18*60*60)
        scsj = time.strftime('%Y-%m-%d %H:%M:%S', time.gmtime(temp))
        tempst = time.strftime('%Y%m%d', time.gmtime(start_time))
        tempst2 = time.strftime('%Y%m%d%H%M%S', time.gmtime(start_time))
        wjbh = cpxh+'@'+tempst2+str(random.randrange(60*60,18*60*60))
        ccwz = 'pe_video/data/'+str(start_time)+'/'+wjbh
        bfwz = 'http://'+self.host+ccwz
        start_time = time.strftime('%Y-%m-%d %H:%M:%S', time.gmtime(start_time))
        upload = random.randrange(0,2)
        insertList['jybh'] = code   #警员编号
        insertList['jyxm'] = name   #警员姓名
        insertList['areaid'] = areaid   #部门ID
        insertList['areaname'] = areaname   #部门名称
        insertList['gzzbh'] = gzzbh    #工作站编号
        insertList['gzz_ip'] = gzz_ip #工作站IP
        insertList['wjbh'] = wjbh    #文件编号
        insertList['start_time'] = start_time  #开始时间
        insertList['wjlx'] = wjlx   #文件类型
        insertList['cpxh'] = cpxh   #产品序号
        insertList['ccwz'] = ccwz   #存储位置
        insertList['bfwz'] = bfwz   #播放位置
        insertList['scsj'] = scsj   #上传时间
        insertList['upload'] = upload  #上传级别
        #print(insertList)
        return insertList
    def insert_pe_video_list(self):
        sql = 'insert into pe_video_list'
        data = self.getInsertInfo()
        fields = []
        info = []
        for x in data:
            fields.append(x)
            info.append("'"+str(data[x])+"'")
        values = ','.join(fields)
        values = '('+values+')'
        datas  = ','.join(info)
        sql = sql + values + 'VALUES ('+datas+')'
        try:
           # 执行sql语句
           self.cursor.execute(sql)
           self.db.commit()
           print('插入成功')
        except:
           # 如果发生错误则回滚
           self.db.rollback()
           print('获取工作站信息发生错误')
           return False
    def db_close(self):
        self.db.close()
if __name__ == '__main__':
    pe_data = PeData('localhost','root','123456','enforce','latin1')
    start = time.time()
    i = 0
    while time.time() - start < 3*60 :
        pe_data.insert_pe_video_list()
        time.sleep(random.randrange(1,4))
        i = i+1
    pe_data.db_close()
    print('3分钟'+str(i)+'条数据插入完毕')