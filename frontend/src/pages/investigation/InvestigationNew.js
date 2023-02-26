import React, {Component} from 'react';
import InvestigationNewForm from "../../components/investigation/InvestigationNewForm";
import {FlexBox} from "../../styled/styles";

class InvestigationNew extends Component {
    render() {
        return (
            <FlexBox z={"column"}>
                <h2>Add new Investigation</h2>
                <InvestigationNewForm/>
            </FlexBox>
        );
    }
}

export default InvestigationNew;