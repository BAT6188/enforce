<?php
/**********************
 *用户
 **********************/
namespace Home\Model\Enforce;

class UserModel extends CommonModel{
    protected $tablename = 'user';

    public function check_exist($where)
    {
        $data = $this->where($where)->find();
        return !empty($data) ? $data : false;
    }
}