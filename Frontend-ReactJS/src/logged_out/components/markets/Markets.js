import React, { Fragment, useEffect } from "react";
import PropTypes from "prop-types";
import LandingSection from "./Landing";
import TableSection from "./TableSection";

function Markets(props) {
  const { selectMarkets } = props;
  useEffect(() => {
    selectMarkets();
  }, [selectMarkets]);
  return (
    <Fragment>
      <LandingSection />
      <TableSection />
    </Fragment>
  );
}

Markets.propTypes = {
  selectMarkets: PropTypes.func.isRequired
};

export default Markets;
