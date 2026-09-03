import { Component, StrictMode } from "react";
import { createRoot } from "react-dom/client";
import App from "./App.jsx";
import "./styles.css";

class ErrorBoundary extends Component {
  constructor(props) {
    super(props);
    this.state = { error: null };
  }

  static getDerivedStateFromError(error) {
    return { error };
  }

  render() {
    if (this.state.error) {
      return <main className="setup"><p className="eyebrow">APPLICATION ERROR</p><h1>Nexus could not load.</h1><p>{this.state.error.message}</p><p>Check the browser console and confirm the Supabase URL and public key in `.env`.</p></main>;
    }
    return this.props.children;
  }
}

createRoot(document.getElementById("root")).render(<StrictMode><ErrorBoundary><App /></ErrorBoundary></StrictMode>);
