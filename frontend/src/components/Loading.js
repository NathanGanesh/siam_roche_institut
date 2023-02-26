import React, {Component} from 'react';
import {Button} from "antd";
import { PoweroffOutlined } from '@ant-design/icons';

export default function Loading(props){
    return (
        <Button type="primary" icon={<PoweroffOutlined />} loading />
    );
}

