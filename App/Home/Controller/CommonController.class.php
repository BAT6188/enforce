<?php
namespace Home\Controller;

use Think\Controller;
use Think\Model;

class CommonController extends Controller {
    /**
     * 将字符串转为utf-8编码
     * @param   $string 需要转换的字符串
     * @return  $value
     */
    public function g2u($string)
    {
        $value = iconv('gbk','utf-8',$string);
        return $value;
    }

    /**
     * 将字符串转为gbk编码
     * @param   $string 需要转换的字符串
     * @return  $value
     */
    public function u2g($string)
    {
        $value = iconv('utf-8','gbk',$string);
        return $value;
    }

    /**
     * 将数组的全部转utf-8编码 包括键名
     * @param  array $data  需要转吗的数组
     * @return array       转码后的数组
     */
    public function g2us($data)
    {
        if(is_array($data)){
            foreach ($data as $key => $value) {
                if(is_array($value)){
                    $value = $this->g2us($value);
                }else{
                    $value = $this->g2u($value);
                }
                $key =  $this->g2u($key);
                $data[$key] = $value;
            }
            return $data;
        }
    }

    /**
     * 将数组的全部转gbk编码 包括键名
     * @param  array $data  需要转吗的数组
     * @return array       转码后的数组
     */
    public function u2gs($data)
    {
        if(is_array($data)){
            foreach ($data as $key => $value) {
                if(is_array($value)){
                    $value = $this->u2gs($value);
                }else{
                    $value = $this->u2g($value);
                }
                $key = $this->u2g($key);
                $data[$key] = $value;
            }
            return $data;
        }
    }
}
