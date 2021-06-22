import React, { useState, forwardRef } from "react";
import PropTypes from "prop-types";
import Divider from '@material-ui/core/Divider';
import {
  withStyles,
  withWidth,
  Tabs,
  Tab
} from "@material-ui/core";

const styles = theme => ({
    transactions: {
      backgroundColor: `#fff`,
      display: `flex`,
      justifyContent: `left`,
      paddingLeft: 40,
    },
    tab:{
        width:120,
    },
});

function Tabsection(props) {
    const { classes } = props;
    const [ tabIndex, setTabIndex] = useState(0);

    const handleChange = (event, newValue) => {
        setTabIndex(newValue);
    };

    return (
        <div className={classes.transactions}>
            <Tabs
                value={tabIndex}
                indicatorColor="primary"
                textColor="primary"
                onChange={handleChange}
                >
                <Tab label="P2P" className={classes.tab}/>
                <Divider orientation="vertical" flexItem />
                <Tab label="Buy Crypto" className={classes.tab}/>
                <Divider orientation="vertical" flexItem />
                <Tab label="Withdraw" className={classes.tab}/>
            </Tabs>
            <Divider />
        </div>
    );
}
Tabsection.propTypes = {
    classes: PropTypes.object,
    width: PropTypes.string,
    theme: PropTypes.object
};

export default withWidth()(
    withStyles(styles, { withTheme: true })(Tabsection)
  );