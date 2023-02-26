import React, {Component, useEffect, useState} from 'react';
import {FlexBox} from "../../styled/styles";
import {GridImages} from "../../styled/globals/StyledFlexBoxContainer";
import Loading from "../../components/Loading";
import createNewEntity from "../../images/img_3.png"
import crossReference from "../../images/img_1.png"
import uploadDocs from "../../images/img_2.png"
import compareOtherData from "../../images/img.png"

import {Card} from "antd";
import {useHistory, useParams} from "react-router-dom";
export default function InvestigationStarted(props){
    const [test, setLoading] = useState(true);
    let history = useHistory();
    let { id } = useParams();

    useEffect(() => {
        setLoading(true)
        const random = Math.random(1000,2000)
        console.log(id)
        const timer = setTimeout(() => {
        }, (random));
        setLoading(false)
        return () => clearTimeout(random);
    }, [])

    const data = [
        {
            title: 'Ant Design Title 1',
            img: createNewEntity,
            to: `/investigation/${id}/createEntity`
        },
        {
            title: 'Ant Design Title 2',
            img: crossReference,
            to: `/investigation/${id}/crossreference`
        },
        {
            title: 'Ant Design Title 3',
            img: uploadDocs,
            to: `/investigation/${id}/upload`
        },
        {
            title: 'Ant Design Title 4',
            img: compareOtherData,
            to: `/investigation/${id}/compare`
        },
    ];

        return (
            test ? <
                Loading/> :
                <GridImages display={"grid"} gridSize="400px" upDown="10" width="100%">
                        {data.map((p) => (
                                    <div className={"col-md-4"} onClick={() => history.push(p.to)}>
                                        <Card cover={<img src={p.img} className={"imgA1"} style={{ height: "150px", objectFit: "fill", cursor: "pointer" }}
                                                          className="p-1"/>} />
                                    </div>
                            ))}
                </GridImages>
        );
}

