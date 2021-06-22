import React, { Fragment } from "react";
import LandingSection from "./Landing";
import Trading from "./Trading";


function Exchange(props) {
  return (
    <Fragment>
      <LandingSection />
      <Trading symbol="BTC/USD"/>
    </Fragment>
  );
}

export default Exchange;
