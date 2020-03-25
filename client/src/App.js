import React, { useState } from 'react';
import './App.css';
import Nav from './Nav';

const App = () => {
  const [limit, setLimit] = useState(0);
  return (
    <div className="container">
      <Nav />
      <div
        className="row"
        style={{ height: '150px', backgroundColor: '#282368' }}
      >
        <div className="col-sm">
          <h1 style={{ color: 'white', position: 'absolute', bottom: '0px' }}>
            My Account
          </h1>
        </div>
      </div>

      <div
        className="row"
        style={{ height: '100px', backgroundColor: '#282368', color: 'white' }}
      >
        <div className="col">
          <div className="row row-cols-2">
            <div className="col">
              <img
                width="80px"
                src="https://s3.amazonaws.com/uifaces/faces/twitter/samgrover/128.jpg"
                alt=""
                className="rounded-circle"
              />
            </div>
            <div className="col-6">
              <p style={{ fontSize: '14px' }}>
                John Doe
                <br />
                Chief Creative Officer
              </p>
            </div>
          </div>
        </div>
        <div className="col">
          <button className="btn btn-warning" style={{ float: 'right' }}>
            Connected
          </button>
        </div>
      </div>
      <div className="row row-cols-2">
        <div className="col-sm infoBox">
          <p>999</p>
          <p>Account Balance</p>
        </div>
        <div className="col-sm infoBox">
          <p>999</p>
          <p>Investments Balance</p>
        </div>
      </div>
      <div className="row row-cols-2">
        <div className="col-sm infoBox">
          <p>99</p>
          <p>Minimum Account Balance</p>
        </div>
        <div className="col-sm infoBox">
          <p>99</p>
          <p>Investment Threshold</p>
        </div>
      </div>
      <div className="row m-1">
        Send
        <div className="row row-cols-2">
          <div className="col-sm">
            <input placeholder="Account" className="form-control" />
          </div>
          <div className="col-sm">
            <input placeholder="Recipient" className="form-control" />
          </div>
        </div>
        <button type="button" className="btn btn-dark btn-block mt-1">
          Send
        </button>
      </div>
      <div className="row m-1">
        Withdraw
        <div className="col-sm">
          <input placeholder="Amount" className="form-control" />
        </div>
        <button type="button" className="btn btn-dark btn-block mt-1">
          Withdraw
        </button>
      </div>
      <div className="row m-1">
        Deposit
        <div className="col-sm">
          <input placeholder="Amount" className="form-control" />
        </div>
        <button type="button" className="btn btn-dark btn-block mt-1">
          Deposit
        </button>
      </div>
      <div className="row m-1">
        Set minimum balance
        <div className="col-sm">
          <input placeholder="Amount" className="form-control" />
        </div>
        <button type="button" className="btn btn-dark btn-block mt-1">
          Set minimum balance
        </button>
      </div>
      <div className="row m-1">
        Set Investment threshold
        <div className="col-sm">
          <label for="customRange1">{limit}</label>
          <input
            type="range"
            className="custom-range"
            id="customRange1"
            onClick={e => setLimit(e.target.value)}
          />
        </div>
        <button type="button" className="btn btn-dark btn-block mt-1">
          Set investment threshold
        </button>
      </div>
    </div>
  );
};

export default App;
