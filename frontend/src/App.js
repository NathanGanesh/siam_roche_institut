import logo from './logo.svg'
import {Route, Routes, browserHistory, Switch} from "react-router-dom";
import React, { lazy, Suspense } from "react";
import './App.css';
import Loading from "./components/Loading";
import {ToastContainer} from "react-toastify";
import Navbar from "./components/navbar/Navbar";
import Dashboard from "./pages/dashboard/Dashboard";
import Investigation from "./pages/investigation/Investigation";
import InvestigationStarted from "./pages/investigation/InvestigationStarted";
import InvestigationCrossReference from "./pages/investigation/InvestigationCrossReference";
import Search from "./pages/Search";
import InvestigationNew from "./pages/investigation/InvestigationNew";
import InvestigationCreateEntity from "./pages/investigation/InvestigationCreateEntity";

function App() {
  return (
    <Suspense fallback={Loading}>
        <Navbar/>
      <ToastContainer/>
      <Switch>
          <Route exact path={"/"} component={Dashboard}/>
          <Route exact path={"/search"} component={Search}/>
          <Route exact path={"/investigation"} component={Investigation}/>
          <Route exact path={"/investigation/new"} component={InvestigationNew} />
          <Route exact path={"/investigation/:id"} component={InvestigationStarted}/>
          <Route exact path={"/investigation/:id/createEntity"} component={InvestigationCreateEntity}/>
          <Route exact path={"/investigation"} component={InvestigationCrossReference}/>
      </Switch>
    </Suspense>
  );
}

export default App;
