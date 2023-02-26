import React, {Component, useContext, useEffect, useState} from 'react';
import {useForm, Controller} from "react-hook-form";
import {InvestigationContext} from "../../context/InvestigationContext";
import {useHistory, useParams} from "react-router-dom";
import {FlexBox} from "../../styled/styles";
import {FlexBoxContainerInput} from "../../styled/globals/AuthBoxContainer";
import InvestigationNewForm from "../../components/investigation/InvestigationNewForm";
import Select from "react-select";
import { Multiselect } from "multiselect-react-dropdown";

export default function InvestigationCreateEntity(props){
    const {
        register,
        handleSubmit,
        control,
        formState: {errors}
    } = useForm();
    const [submitting, setSubmitting] = useState(false);
    const [loading, setLoading] = useState(true)
    const [countryValue, setCountryValue] = useState(null);
    const [serverErrors, setServerErrors] = useState([]);
    const {investigations, setInvestigations } = useContext(InvestigationContext);
    let history = useHistory();
    let { id } = useParams();

    useEffect(() => {
    },[]);

    const options = [
        { value: 'Address', label: 'Address' },
        { value: 'Airplane', label: 'Airplane' },
        { value: 'Note', label: 'Note' },
        { value: 'Organization', label: 'Organization' },
        { value: 'Bank account', label: 'Bank account' },
        { value: 'Transaction', label: 'Transaction' },
        { value: 'Company', label: 'Company' },
        { value: 'Project', label: 'Project' },
        { value: 'Other', label: 'Other' },
    ];

    const Comp = () =>{
        return (
            <FlexBox z={"column"}>
            <h2>Add new entity</h2>
            <Form/>
        </FlexBox>)
    }

    function statusDropdownHandleChange(name) {
        console.log(name)
        console.log('working')
    }

    const Form = () => {
     return (<FlexBox  z={"row"} x={"flex-start"}>
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
                 history.push(`/investigation/${id}`)
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
                 <label htmlFor="name">Name</label>
                 <input
                     {...register("name", {required: "Fill in"})}
                     id="name"
                 />
                 {errors.name && <p className={"error"}>{errors.name.message}</p>}
             </FlexBoxContainerInput>
             <FlexBoxContainerInput  z={"row"} x={"flex-start"}>
                 <label htmlFor="status">Entity type</label>
                 <Controller
                     name="status"
                     control={control}
                     render={({ field }) => (
                         <Select
                             // defaultValue={options[0]}
                             {...field}
                             isClearable
                             isSearchable={false}
                             className="react-dropdown"
                             classNamePrefix="dropdown"
                             options={options}
                         />
                     )}
                 />
             </FlexBoxContainerInput>

             <FlexBoxContainerInput z={"column"} y={"none"}>
                 <label htmlFor="summary">Entity summary</label>
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
     </FlexBox>)
    }

    return <>
    <Comp/>
    </>
}