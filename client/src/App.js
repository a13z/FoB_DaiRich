import React from 'react';
import './App.css';
import Nav from './Nav';

function App() {
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
          <img
            width="80px"
            src="https://s3.amazonaws.com/uifaces/faces/twitter/samgrover/128.jpg"
            class="img-thumbnail"
          />
        </div>
        <div className="col">Connected</div>
      </div>
      <div className="row">
        <div className="col-sm">Account Balance</div>
        <div className="col-sm">Investments Balance</div>
      </div>
      <div className="row">
        <div className="col-sm">Minimum Account Balance</div>
        <div className="col-sm">Investment Threshold</div>
      </div>
      <div className="row">
        <div className="col-sm">
          Send Eth
          <input placeholder="Account" />
          <input placeholder="Recipient" />
          <button>Send</button>
        </div>
      </div>
    </div>
  );
}

export default App;
