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
        //$importType = I('importType',1);    //下载类型
        $total = I('total');                 //下载数量
        $query = I('query');                //请求数据
        $fields = I('fields');               //field name
        $query['rows'] = (int)$total;
        //print_r($query);
        //向链接请求数据
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, 'http://localhost'.$listUrl);
        //echo 'http://localhsot'.$listUrl;
        //print_r($query);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $query);             //post发送数据
        curl_setopt($ch, CURLOPT_HEADER, 0);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        $res = curl_exec($ch);
        $data = json_decode($res,true);
        if($data['total'] && $data['total'] > 0){
            //统计查询处理
            if(array_key_exists('data', $data)){
                $rows = [];
                foreach ($data['data'] as $value) {
                    foreach ($value['rows'] as $val) {
                        $val['name'] = $value['name'];
                        $rows[] =  $val;
                    }
                }
            }
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
    /**
     * 根据数据生成excel保存到服务器 返回保存地址
     * @param  array $rows  数据
     * @param  array $field 头行
     * @return string        文件地址
     */
    public function saveExcel($rows,$fields)
    {
        $columnTotal = count($fields);
        //生成需要设置的列
        $first = 'A';
        for ($i=0; $i < $columnTotal; $i++) {
            $abcArr[] = $first;
            $first++;
        }
        //导出Excel表格
        require_once APP_PATH.'Common/PHPExcel.php';
        require_once APP_PATH.'Common/PHPExcel/Writer/Excel5.php';     // 用于其他低版本xls
        /* 实例化类 */
        $objPHPExcel = new \PHPExcel();
        /* 设置输出的excel文件为2007兼容格式 */
        $objWriter=new \PHPExcel_Writer_Excel5($objPHPExcel);//非2007格式
        //$objWriter = new \PHPExcel_Writer_Excel2007($objPHPExcel);
        /* 设置当前的sheet */
        $objPHPExcel->setActiveSheetIndex(0);
        $objActSheet = $objPHPExcel->getActiveSheet();
        /*设置宽度*/
        foreach ($abcArr as $abc) {
            $objPHPExcel->getActiveSheet()->getColumnDimension($abc)->setWidth(15);
        }
        /* sheet标题 */
        $sheetTitle = 'title1';
        $objActSheet->setTitle($sheetTitle);
        $excelFileName = date(YmdHis).rand(10,99);
        //第一行字体及颜色
        $objStyle1 = $objActSheet->getStyle('1');
        $objFont1 = $objStyle1->getFont();
        $objFont1->setName('黑体');
        $objFont1->setSize(12);
        $col = $fields;
        $cols = array_values($col);
        $colks = array_keys($col);
        //设置投行标题
        foreach ($abcArr as $key => $abc) {
            $objActSheet->setCellValue($abc.'1',$cols[$key]);
            $cola[$abc] = $colks[$key];
        }
        //填充数据
        $data = $rows;
        $i = 2;
        foreach($data as $value)
        {
            /* excel文件内容 */
            $j = 'A';
            foreach ($value as $key=>$val) {
                $objActSheet->setCellValue($j.$i,$value[$cola[$j]]);
                $j++;
            }
            $i++;
        }
        //Excel5;
        $id = session('id');

        $url = "./Public/download/repWork_".$excelFileName."{$id}.xls";
        //echo $url;
        try
        {
            $objWriter->save($url);
            $url = substr($url, 1);
            $host = isset($_SERVER['HTTP_X_FORWARDED_HOST']) ? $_SERVER['HTTP_X_FORWARDED_HOST'] : (isset($_SERVER['HTTP_HOST']) ? $_SERVER['HTTP_HOST'] : C('DB_HOST'));
            return 'http://'.$host.__ROOT__.$url;
        }
        catch(Exception $e)
        {
            return false;
        }
    }
}
