import React, { useContext, useState } from 'react'

export const InvestigationContext = React.createContext()


export default function InvestigationProvider({ children }) {
    const [investigations, setInvestigations] = useState([{"name":"test", "summary": "mark"}, {"name":"snackbar", "summary": "patat"}])

    const [entities, setEntities] = useState([
        {"name": "Karel jansen", "type": "Person"}
    ])

    return (
        <InvestigationContext.Provider value={{
            investigations, setInvestigations, entities, setEntities }}>
            {children}
        </InvestigationContext.Provider>
    )
}
