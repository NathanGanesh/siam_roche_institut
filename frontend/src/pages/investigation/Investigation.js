import React, {Component, useContext} from 'react';
import {ButtonWithIcon, StyledButtonDelete, StyledButtonLink} from "../../styled/globals/StyledRouterLink";
import {FlexBox} from "../../styled/styles";
import {InvestigationContext} from "../../context/InvestigationContext";
import {GridImages} from "../../styled/globals/StyledFlexBoxContainer";
import InvestigationListItem from "../../components/investigation/InvestigationListItem";
import Loading from "../../components/Loading";
import {Avatar, List} from "antd";
import logo from "../../images/suitcase.png"
import {useHistory} from "react-router-dom";
function Investigation(props){

    const {investigations, setInvestigations } = useContext(InvestigationContext);
    let history = useHistory();

    const handleOnClick = (e, naam) => {
        history.push(`/investigation/${naam}`)
    }

        return (
            <div >
                <h1>Investigation</h1>
                <p>Investigations let you upload and share documents and data which belong to a particular story. You can upload PDFs, email archives or spreadsheets, and they will be made easy to search and browse.</p>
                <StyledButtonLink text="New Investigation" to2={"/investigation/new"} icon={"fa-suitcase"}/>
                {investigations.length <= 0 ? <div>
                    No investigations found
                </div> :  <List
                    style={{cursor:'pointer'}}
                    itemLayout="horizontal"
                    dataSource={investigations}
                    renderItem={(item) => (
                        <List.Item onClick={(e) => handleOnClick(e,item.name)}>
                            <List.Item.Meta
                                avatar={<Avatar src={logo} />}
                                title={item.name}
                                description={item.summary}
                            />
                        </List.Item>
                    )}
                />}
            </div>
        );
}

export default Investigation;