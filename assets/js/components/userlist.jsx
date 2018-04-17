import React from 'react';
import { Button, FormGroup, Label, Input, Card, CardTitle, CardBody, CardText, CardSubtitle } from 'reactstrap';
import {Redirect} from 'react-router-dom';

export default function Userlist(props) { 
  if(props.users==false)
	return <Redirect to="/" />;   
  
  let user = _.find(props.users, (nn) => nn.id==props.token.user_id);
  let wallet = _.find(props.wallets, (ww) => ww.user.id==props.token.user_id);
  let credit, debit, wallet_info; 
  credit=debit=wallet_info=0;
  if(user.credit)
    credit = user.credit;
  if(user.debit)
    debit = user.debit;
  if(wallet)
    wallet_info = wallet.balance;
  return <div>
	      <p>{user.name}</p>
	      <p>{user.email}</p>
	      <Card>
		<CardBody>
		  <CardTitle>Wallet Information</CardTitle>
		  <CardText>Account Balance: BTC {wallet_info} </CardText>
		</CardBody>
	      </Card>
              <Card>
		<CardBody>
		  <CardTitle>Loan Information</CardTitle>
		  <CardText>Amount Borrowed</CardText>
		  <CardText>${credit}</CardText>
		  <CardText>Amount Lended</CardText>
		  <CardText>${debit}</CardText>
		</CardBody>
	      </Card>
	</div>;
}
