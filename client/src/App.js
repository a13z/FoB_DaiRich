import React, { Component } from 'react';
import HybridBankContract from './contracts/HybridBank.json';
import getWeb3 from './getWeb3';
import Nav from './Nav';
import IERC20 from './contracts/IERC20.json';
import './App.css';

const HYBRID_BANK_CONTRACT_ADDRESS =
	'0xF1769060B1773b06780B3786D8cdd05f9B39b688';

class App extends Component {
	state = {
		accounts: null,
		balance: 0,
		contract: null,
		invested: 0,
		investedWithInterest: 0,
		investmentThreshold: 0,
		minBal: 0,
		setInvestmentThreshold: 50,
		setDepositAmount: '',
		setMinBal: '',
		web3: null,
		sendTo: '',
		sendAmount: '',
		hide: false,
		erc20: null,
		disabledEnroll: true,
		approveAmount: '',
		loading: false,
	};

	componentDidMount = async () => {
		try {
			// Get network provider and web3 instance.
			const web3 = await getWeb3();

			// Use web3 to get the user's accounts.
			const accounts = await web3.eth.getAccounts();

			// Get the contract instance.
			const instance = new web3.eth.Contract(
				HybridBankContract,
				HYBRID_BANK_CONTRACT_ADDRESS
			);
			const instance2 = new web3.eth.Contract(
				IERC20,
				'0xFf795577d9AC8bD7D90Ee22b6C1703490b6512FD'
			);
			// Set web3, accounts, and contract to the state, and then proceed with an
			// example of interacting with the contract's methods.
			this.setState(
				{ web3, accounts, contract: instance, erc20: instance2 },
				this.isAccountEnrolled
			);
		} catch (error) {
			// Catch any errors for any of the above operations.
			alert(
				`Failed to load web3, accounts, or contract. Check console for details.`
			);
			console.error(error);
		}
	};

	handleChange(event) {
		const { name, value } = event.target;
		this.setState({ [name]: value });
	}

	setInvestmentThreshold = async () => {
		const { contract, accounts, setInvestmentThreshold } = this.state;
		await contract.methods
			.setInvestmentThreshold(setInvestmentThreshold)
			.send({ from: accounts[0] });
		this.setState({
			investmentThreshold: setInvestmentThreshold,
		});
	};

	setMinBalance = async () => {
		const { contract, accounts, setMinBal } = this.state;
		await contract.methods.setMinBalance(setMinBal).send({ from: accounts[0] });
		this.setState({
			minBal: setMinBal,
		});
	};

	setDepositAmount = async () => {
		const { contract, accounts, setDepositAmount } = this.state;
		this.setState({ loading: true });
		await contract.methods
			.deposit(setDepositAmount)
			.send({ from: accounts[0] });
		this.setState({ loading: false });
		this.getAccountStats();
	};

	sendDai = async () => {
		const { contract, accounts, sendTo, sendAmount } = this.state;
		await contract.methods.pay(sendTo, sendAmount).send({ from: accounts[0] });
	};

	isAccountEnrolled = async () => {
		const { contract, accounts } = this.state;
		const enrolled = await contract.methods
			.isAccountEnrolled()
			.call({ from: accounts[0] });
		if (enrolled) {
			this.setState({ hide: false });
			this.getAccountStats();
		} else {
			this.setState({ hide: true });
		}
	};

	getAccountStats = async () => {
		const { contract, accounts } = this.state;
		const bal = await contract.methods.balance().call({ from: accounts[0] });
		const minBal = await contract.methods
			.getMinBalance()
			.call({ from: accounts[0] });
		const investmentThreshold = await contract.methods
			.getInvestmentThreshold()
			.call({ from: accounts[0] });

		this.setState({
			balance: bal[0],
			invested: bal[1],
			investedWithInterest: bal[2],
			minBal,
			investmentThreshold,
		});
	};

	approve = async () => {
		const { erc20, accounts, approveAmount } = this.state;
		this.setState({ loading: true });
		const erc20Res = await erc20.methods
			.approve(HYBRID_BANK_CONTRACT_ADDRESS, approveAmount)
			.send({ from: accounts[0] });
		this.setState({ loading: false });

		if (erc20Res.status) {
			this.setState({ disabledEnroll: false });
		}
	};

	enroll = async () => {
		const { contract, accounts } = this.state;
		this.setState({ loading: true });
		const res = await contract.methods.enroll().send({ from: accounts[0] });
		this.setState({ loading: false });

		if (res.status) {
			this.isAccountEnrolled();
		}
	};

	render() {
		if (!this.state.web3) {
			return <div>Loading Web3, accounts, and contract...</div>;
		}
		return (
			<div className='container'>
				<Nav />
				<div style={{ display: this.state.hide ? 'block' : 'none' }}>
					<div className='alert alert-danger' role='alert'>
						You must enroll first!
					</div>
					<div className='row'>
						<div className='col'>
							<input
								name='approveAmount'
								type='number'
								className='form-control'
								value={this.state.approveAmount}
								onChange={(e) => this.handleChange(e)}
								placeholder='Enter amount to deposit into bank account'
							/>
							<br />
							<button
								type='button'
								className='btn btn-success'
								onClick={() => this.approve()}
							>
								{this.state.loading ? 'Processing...' : 'Approve'}
							</button>
						</div>
					</div>
					<div className='row pt-3'>
						<div className='col'>
							<button
								type='button'
								className='btn btn-success'
								onClick={() => this.enroll()}
								disabled={this.state.disabledEnroll}
							>
								{this.state.loading ? 'Processing...' : 'Enroll'}
							</button>
						</div>
					</div>
				</div>
				<div style={{ display: this.state.hide ? 'none' : 'block' }}>
					<div
						className='row'
						style={{ height: '150px', backgroundColor: '#282368' }}
					>
						<div className='col-sm'>
							<h1
								style={{ color: 'white', position: 'absolute', bottom: '0px' }}
							>
								My Account
							</h1>
						</div>
					</div>
					<div
						className='row'
						style={{
							height: '100px',
							backgroundColor: '#282368',
							color: 'white',
						}}
					>
						<div className='col'>
							<div className='row row-cols-2'>
								<div className='col'>
									<img
										width='80px'
										src='https://s3.amazonaws.com/uifaces/faces/twitter/samgrover/128.jpg'
										alt=''
										className='rounded-circle'
									/>
								</div>
								<div className='col-6'>
									<p style={{ fontSize: '14px' }}>
										John Doe
										<br />
										Chief Creative Officer
									</p>
								</div>
							</div>
						</div>
						<div className='col'>
							<button className='btn btn-warning' style={{ float: 'right' }}>
								{this.state.web3.currentProvider.isConnected
									? 'Connected'
									: 'Not Connected'}
							</button>
						</div>
					</div>
					<div className='row row-cols-2'>
						<div className='col-sm infoBox'>
							<p>{this.state.balance}</p>
							<p>Account Balance</p>
						</div>
						<div className='col-sm infoBox'>
							<p>{this.state.invested}</p>
							<p>Investments Balance</p>
						</div>
					</div>
					<div className='row row-cols-2'>
						<div className='col-sm infoBox'>
							<p>{this.state.minBal}</p>
							<p>Minimum Account Balance</p>
						</div>
						<div className='col-sm infoBox'>
							<p>{this.state.investmentThreshold}</p>
							<p>Investment Threshold</p>
						</div>
					</div>
					<div className='row m-1'>
						Send
						<div className='row row-cols-2'>
							<div className='col-sm'>
								<input
									placeholder='Recipient'
									className='form-control'
									name='sendTo'
									value={this.state.sendTo}
									onChange={(e) => this.handleChange(e)}
								/>
							</div>
							<div className='col-sm'>
								<input
									placeholder='Amount'
									className='form-control'
									name='sendAmount'
									value={this.state.sendAmount}
									onChange={(e) => this.handleChange(e)}
								/>
							</div>
						</div>
						<button
							type='button'
							className='btn btn-dark btn-block mt-1'
							onClick={() => this.sendDai()}
						>
							{this.state.loading ? 'Processing...' : 'Send'}
						</button>
					</div>
					<div className='row m-1'>
						Withdraw
						<div className='col-sm'>
							<input placeholder='Amount' className='form-control' disabled />
						</div>
						<button
							type='button'
							className='btn btn-dark btn-block mt-1'
							disabled
						>
							{this.state.loading ? 'Processing...' : 'Withdraw'}
						</button>
					</div>
					<div className='row m-1'>
						Deposit
						<div className='col-sm'>
							<input
								placeholder='Amount'
								className='form-control'
								name='setDepositAmount'
								onChange={(e) => this.handleChange(e)}
								value={this.state.setDepositAmount}
							/>
						</div>
						<button
							type='button'
							className='btn btn-dark btn-block mt-1'
							onClick={() => this.setDepositAmount()}
						>
							{this.state.loading ? 'Processing...' : 'Deposit'}
						</button>
					</div>
					<div className='row m-1'>
						Set minimum balance
						<div className='col-sm'>
							<input
								placeholder='Amount'
								name='setMinBal'
								className='form-control'
								value={this.state.setMinBal}
								onChange={(e) => this.handleChange(e)}
							/>
						</div>
						<button
							type='button'
							className='btn btn-dark btn-block mt-1'
							onClick={() => this.setMinBalance()}
						>
							{this.state.loading ? 'Processing...' : 'Set minimum balance'}
						</button>
					</div>
					<div className='row m-1'>
						Set Investment threshold
						<div className='col-sm'>
							<label htmlFor='customRange1'>
								{this.state.setInvestmentThreshold}
							</label>
							<input
								type='range'
								className='custom-range'
								id='customRange1'
								onChange={(e) =>
									this.setState({ setInvestmentThreshold: e.target.value })
								}
							/>
						</div>
						<button
							type='button'
							className='btn btn-dark btn-block mt-1'
							onClick={() => this.setInvestmentThreshold()}
						>
							{this.state.loading
								? 'Processing...'
								: 'Set investment threshold'}
						</button>
					</div>
				</div>
			</div>
		);
	}
}

export default App;
