import React, {useContext, useRef, useState} from "react";
import {useForm} from "react-hook-form";
import {FlexBox} from "../../styled/styles";
import styled from "styled-components";
import {FlexBoxContainerInput} from "../../styled/globals/AuthBoxContainer";
import {InvestigationContext} from "../../context/InvestigationContext";
import {useHistory} from "react-router-dom";

export default function InvestigationNewForm() {
    const {
        register,
        handleSubmit,
        formState: {errors}
    } = useForm();
    const [submitting, setSubmitting] = useState(false);
    const [serverErrors, setServerErrors] = useState([]);
    const {investigations, setInvestigations } = useContext(InvestigationContext);
    let history = useHistory();

    return(
        <FlexBox>
            <form
                onSubmit={handleSubmit(async (formData) => {
                    setSubmitting(true);
                    console.log(formData)
                    setServerErrors([]);
                    let dataInvestigation = {
                        'name': formData.name,
                        'summary': formData.summary
                    }
                    console.log(dataInvestigation, "datainvest")
                    investigations.push(dataInvestigation)
                    setInvestigations(investigations);
                    history.push("/investigation")
                    // await createUser(formData.naam, formData.achterNaam, formData.email, formData.wachtwoord, formData.terms).then((resp, err) => {
                    //     if (resp.data){
                    //
                    //     }else{
                    //
                    //     }
                    //     console.log(resp)
                    // })


                    // const token = await reRef.current.executeAsync();
                    // reRef.current.reset();
                    // try{
                    //     await createUser()
                    // }
                    // const response = await fetch("/api/auth", {
                    //     method: "POST",
                    //     headers: {
                    //         "Content-Type": "application/json",
                    //     },
                    //     body: JSON.stringify({
                    //         name: formData.name,
                    //         email: formData.email,
                    //         password: formData.password,
                    //         terms: formData.terms,
                    //         // token,
                    //     }),
                    // });
                    // const data = await response.json();
                    //
                    // if (data.errors) {
                    //     setServerErrors(data.errors);
                    // } else {
                    //     console.log("success, redirect to home page");
                    // }

                    setSubmitting(false);
                })}
            >
                <FlexBoxContainerInput z={"column"} y={"none"}>
                    <label htmlFor="name">Investigation name</label>
                    <input
                        {...register("name", {required: "Fill in"})}
                        id="name"
                    />
                    {errors.name && <p className={"error"}>{errors.name.message}</p>}
                </FlexBoxContainerInput>
                <FlexBoxContainerInput z={"column"} y={"none"}>
                    <label htmlFor="summary">Investigation summary</label>
                    <input
                        {...register("summary", {required: "Fill in"})}
                        id="summary"
                    />
                    {errors.summary && <p className={"error"}>{errors.summary.message}</p>}
                </FlexBoxContainerInput>

                <FlexBoxContainerInput z={"column"}>
                    <button type="submit" className={"submit-auth-btn"}>
                        Submit
                    </button>
                </FlexBoxContainerInput>


                {serverErrors && (
                    <ul>
                        {serverErrors.map((error) => (
                            <li key={error}>{error}</li>
                        ))}
                    </ul>
                )}
            </form>
        </FlexBox>
    )
}