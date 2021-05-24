import React, { memo } from "react";
import PropTypes from "prop-types";
import { Switch } from "react-router-dom";
import { withStyles } from "@material-ui/core";
import Dashboard from "./dashboard/Dashboard";
import Posts from "./posts/Posts";
import Subscription from "./subscription/Subscription";
import PropsRoute from "../../shared/components/PropsRoute";
import Rewardcenter from "./rewardcenter/Rewardcenter";
import Payment from "./payment/Payment";
import Taskcenter from "./taskcenter/Taskcenter";
import Security from "./security/Security";
import BasicInfo from "./Settings/BasicInfo/Basicinfo";
import API from "./Settings/API/API";
import Preferences from "./Settings/Preferences/Preferences";

const styles = (theme) => ({
  wrapper: {
    margin: theme.spacing(1),
    width: "auto",
    [theme.breakpoints.up("xs")]: {
      width: "95%",
      marginLeft: "auto",
      marginRight: "auto",
      marginTop: theme.spacing(4),
      marginBottom: theme.spacing(4),
    },
    [theme.breakpoints.up("sm")]: {
      marginTop: theme.spacing(6),
      marginBottom: theme.spacing(6),
      width: "90%",
      marginLeft: "auto",
      marginRight: "auto",
    },
    [theme.breakpoints.up("md")]: {
      marginTop: theme.spacing(6),
      marginBottom: theme.spacing(6),
      width: "82.5%",
      marginLeft: "auto",
      marginRight: "auto",
    },
    [theme.breakpoints.up("lg")]: {
      marginTop: theme.spacing(6),
      marginBottom: theme.spacing(6),
      width: "70%",
      marginLeft: "auto",
      marginRight: "auto",
    },
  },
});

function Routing(props) {
  const {
    classes,
    EmojiTextArea,
    ImageCropper,
    Dropzone,
    DateTimePicker,
    pushMessageToSnackbar,
    posts,
    transactions,
    toggleAccountActivation,
    CardChart,
    statistics,
    targets,
    setTargets,
    setPosts,
    isAccountActivated,
    selectDashboard,
    selectRewardcenter,
    selectPayment,
    selectTaskcenter,
    selectSecurity,
    selectBasicinfo,
    selectAPI,
    selectPreferences,
    selectPosts,
    selectSubscription,
    openAddBalanceDialog,
  } = props;
  return (
    <div className={classes.wrapper}>
      <Switch>
        <PropsRoute
          path="/excoincial/posts"
          component={Posts}
          EmojiTextArea={EmojiTextArea}
          ImageCropper={ImageCropper}
          Dropzone={Dropzone}
          DateTimePicker={DateTimePicker}
          pushMessageToSnackbar={pushMessageToSnackbar}
          posts={posts}
          setPosts={setPosts}
          selectPosts={selectPosts}
        />
        <PropsRoute
          path="/excoincial/subscription"
          component={Subscription}
          transactions={transactions}
          pushMessageToSnackbar={pushMessageToSnackbar}
          selectSubscription={selectSubscription}
          openAddBalanceDialog={openAddBalanceDialog}
        />
        <PropsRoute
          path="/excoincial/rewardcenter"
          component={Rewardcenter}
          selectRewardcenter={selectRewardcenter}
        />
        <PropsRoute
          path="/excoincial/payment"
          component={Payment}
          selectPayment={selectPayment}
        />
        <PropsRoute
          path="/excoincial/task-center"
          component={Taskcenter}
          selectTaskcenter={selectTaskcenter}
        />
        <PropsRoute
          path="/excoincial/security"
          component={Security}
          selectSecurity={selectSecurity}
        />
        <PropsRoute
          path="/excoincial/settings"
          component={BasicInfo}
          selectBasicinfo={selectBasicinfo}
        />
        <PropsRoute
          path="/excoincial/basicinfo"
          component={BasicInfo}
          selectBasicinfo={selectBasicinfo}
        />
        <PropsRoute
          path="/excoincial/api"
          component={API}
          selectAPI={selectAPI}
        />
        <PropsRoute
          path="/excoincial/preferences"
          component={Preferences}
          selectPreferences={selectPreferences}
        />
        <PropsRoute
          path=""
          component={Dashboard}
          toggleAccountActivation={toggleAccountActivation}
          pushMessageToSnackbar={pushMessageToSnackbar}
          CardChart={CardChart}
          statistics={statistics}
          targets={targets}
          setTargets={setTargets}
          isAccountActivated={isAccountActivated}
          selectDashboard={selectDashboard}
        />        
      </Switch>
    </div>
  );
}

Routing.propTypes = {
  classes: PropTypes.object.isRequired,
  EmojiTextArea: PropTypes.elementType,
  ImageCropper: PropTypes.elementType,
  Dropzone: PropTypes.elementType,
  DateTimePicker: PropTypes.elementType,
  pushMessageToSnackbar: PropTypes.func,
  setTargets: PropTypes.func.isRequired,
  setPosts: PropTypes.func.isRequired,
  posts: PropTypes.arrayOf(PropTypes.object).isRequired,
  transactions: PropTypes.arrayOf(PropTypes.object).isRequired,
  toggleAccountActivation: PropTypes.func,
  CardChart: PropTypes.elementType,
  statistics: PropTypes.object.isRequired,
  targets: PropTypes.arrayOf(PropTypes.object).isRequired,
  isAccountActivated: PropTypes.bool.isRequired,
  selectDashboard: PropTypes.func.isRequired,
  selectRewardcenter: PropTypes.func.isRequired,
  selectPayment: PropTypes.func.isRequired,
  selectTaskcenter : PropTypes.func.isRequired,
  selectSecurity : PropTypes.func.isRequired,
  selectBasicinfo : PropTypes.func.isRequired,
  selectAPI : PropTypes.func.isRequired,
  selectPreferences : PropTypes.func.isRequired,
  selectPosts: PropTypes.func.isRequired,
  selectSubscription: PropTypes.func.isRequired,
  openAddBalanceDialog: PropTypes.func.isRequired,
};

export default withStyles(styles, { withTheme: true })(memo(Routing));
