<?php
namespace Home\Controller;

class FunctionController extends CommonController {
    /**
     * 单张图片下载
     * @param string $imgUrl  图片地址(服务器地址，http地址)
     * @return 输出图片
     */
    public function downImage()
    {
        $imgUrl = I('imgUrl');
        //判断图片地址是否带有http地址，有的话下载后传图片
        $index = strstr($imgUrl, 'http');
        $img = basename($imgUrl);
        if($index){
            $tempPath = './Public/download/Temp/'.date('Ymd').'/';
            if(!file_exists($tempPath)){
                mkdir($tempPath);
            }
            $content = file_get_contents($imgUrl);
            file_put_contents($tempPath.$img, $content);
            $imgUrl = $tempPath.$img;
        }
        if($imgUrl != ''){
            header ( "Cache-Control: max-age=0" );
            header ( "Content-Description: File Transfer" );
            header ( 'Content-disposition: attachment; filename=' . basename ( $imgUrl ) ); // 文件名
            #header ( "Content-Type: application/zip" ); // zip格式的
            #header ( "Content-Transfer-Encoding: binary" ); // 告诉浏览器，这是二进制文件
            header ( 'Content-Length: ' . filesize ( $imgUrl ) ); // 告诉浏览器，文件大小
            readfile ( $imgUrl );//输出文件;
        }else{
            exit('没有图片下载，或者服务器获取图片失败！');
        }
    }
        /**
     * 导出excel
     * @return
     */
    public function exportExcel()
    {
        $listUrl = I('listUrl');            //请求数据的url地址
        $total = I('total');                 //下载数量
        $query = I('query');                //请求数据
        $fields = I('fields');               //field name

        $listUrl = '/enforce/index.php/Home/Media/work_emp_sat';
        $fields = ['num'=>'总数','video'=>'视频','picture'=>'图片','vioce'=>'音频'];
        $total = 20;

        //$query['rows'] = (int)$total;
        //向链接请求数据
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, 'http://localhost'.$listUrl);
        //echo 'http://localhsot'.$listUrl;
        //print_r($query);
        //curl_setopt($ch, CURLOPT_POSTFIELDS, $query);             //post发送数据
        curl_setopt($ch, CURLOPT_HEADER, 0);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        $res = curl_exec($ch);
        $data = json_decode($res,true);
        $this->ajaxReturn($data);
        if($data['total'] && $data['total'] > 0){
            //表格查询处理
            if(array_key_exists('rows', $data)){
                $rows = $data['rows'];
            }
            $res = $this->saveExcel($rows,$fields);
            if($res){
                $result['status'] = true;
                $result['message'] = '成功。';
                $result['fileUrl'] = $res;
                $this->ajaxReturn($result);
            }else{
                $result['status'] = false;
                $result['message'] = '可能原因：服务器权限不足。';
                $result['fileUrl'] = $res;
                $this->ajaxReturn($result);
            }
        }else{
            $result['status'] = false;
            $result['message'] = '获取数据失败，或者没有数据。';
            $result['fileUrl'] = '';
            $this->ajaxReturn($result);
        }
    }
}
