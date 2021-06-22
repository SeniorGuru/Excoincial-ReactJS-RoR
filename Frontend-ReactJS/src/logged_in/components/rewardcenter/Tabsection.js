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
      marginLeft:40
    }
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
                <Tab label="All (0)" />
                <Divider orientation="vertical" flexItem />
                <Tab label="Bonus Voucher (0)" />
                <Divider orientation="vertical" flexItem />
                <Tab label="Trial Fund (0)" />
                <Divider orientation="vertical" flexItem />
                <Tab label="VIP Upgrade (0)" />
                <Divider orientation="vertical" flexItem />
                <Tab label="Cash Voucher (0)" />
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