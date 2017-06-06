<?php
/**
 * 将字符串转为utf-8编码
 * @param   $string 需要转换的字符串
 * @return  $value
 */
function g2u($string)
{
    $value = iconv('gbk','utf-8',$string);
    return $value;
}

/**
 * 将字符串转为gbk编码
 * @param   $string 需要转换的字符串
 * @return  $value
 */
function u2g($string)
{
    $value = iconv('utf-8','gbk',$string);
    return $value;
}

/**
 * 将数组的全部转utf-8编码 包括键名
 * @param  array $data  需要转吗的数组
 * @return array       转码后的数组
 */
function g2us($data)
{
    if(is_array($data)){
        foreach ($data as $key => $value) {
            if(is_array($value)){
                $value = g2us($value);
            }else{
                $value = g2u($value);
            }
            $key = g2u($key);
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
function u2gs($data)
{
    if(is_array($data)){
        foreach ($data as $key => $value) {
            if(is_array($value)){
                $value = u2gs($value);
            }else{
                $value = u2g($value);
            }
            $key = u2g($key);
            $data[$key] = $value;
        }
        return $data;
    }
}
