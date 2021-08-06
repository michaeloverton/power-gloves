import "./App.css";
import axios from "axios";
import { useState } from "react";
import { Button, Row, Col, Container, Dropdown } from "react-bootstrap";

const backendUrl = "http://localhost:4000";

function App() {
  const [key, setKey] = useState("C");
  const [octaveCount, setOctaveCount] = useState(2);
  const [root, setRoot] = useState(3);

  const updateRoot = async () => {
    const rootNote = key + root;
    try {
      await axios.get(`${backendUrl}/updateRoot?root=${rootNote}`);
      // await fetch(`${backendUrl}/updateRoot?root=${rootNote}`);
    } catch (err) {
      console.log(err);
    }
  };

  const playNote = async () => {
    try {
      await axios.get(`${backendUrl}/play`);
      // await fetch(`${backendUrl}/play`);
      console.log("successfully fetched");
    } catch (err) {
      console.log(err);
    }
  };

  return (
    <Container className="App my-5 mx-5">
      <Row className="my-2 h2">
        <Col>
          <b>POWER GLOVE</b>
        </Col>
      </Row>

      <Row className="my-2">
        <Col>
          <Button>Power</Button>
        </Col>
        <Col>
          <Button>Debug</Button>
        </Col>
        <Col>
          <Button>Kill MIDI</Button>
        </Col>
      </Row>

      <Row className="my-2">
        <Col>
          <Dropdown>
            <Dropdown.Toggle>Key: {key}</Dropdown.Toggle>

            <Dropdown.Menu>
              <Dropdown.Item
                onClick={() => {
                  setKey("C");
                  updateRoot();
                }}
              >
                C
              </Dropdown.Item>
              <Dropdown.Item
                onClick={() => {
                  setKey("C#");
                  updateRoot();
                }}
              >
                C#
              </Dropdown.Item>
              <Dropdown.Item
                onClick={() => {
                  setKey("D");
                  updateRoot();
                }}
              >
                D
              </Dropdown.Item>
            </Dropdown.Menu>
          </Dropdown>
        </Col>

        <Col>
          <Dropdown>
            <Dropdown.Toggle>Root: {root}</Dropdown.Toggle>

            <Dropdown.Menu>
              <Dropdown.Item onClick={() => setRoot(1)}>1</Dropdown.Item>
              <Dropdown.Item onClick={() => setRoot(2)}>2</Dropdown.Item>
              <Dropdown.Item onClick={() => setRoot(3)}>3</Dropdown.Item>
              <Dropdown.Item onClick={() => setRoot(4)}>4</Dropdown.Item>
              <Dropdown.Item onClick={() => setRoot(5)}>5</Dropdown.Item>
              <Dropdown.Item onClick={() => setRoot(6)}>6</Dropdown.Item>
            </Dropdown.Menu>
          </Dropdown>
        </Col>

        <Col>
          <Dropdown>
            <Dropdown.Toggle>Octaves: {octaveCount}</Dropdown.Toggle>

            <Dropdown.Menu>
              <Dropdown.Item onClick={() => setOctaveCount(1)}>1</Dropdown.Item>
              <Dropdown.Item onClick={() => setOctaveCount(2)}>2</Dropdown.Item>
              <Dropdown.Item onClick={() => setOctaveCount(3)}>3</Dropdown.Item>
              <Dropdown.Item onClick={() => setOctaveCount(4)}>4</Dropdown.Item>
            </Dropdown.Menu>
          </Dropdown>
        </Col>
      </Row>

      <Row>
        <Col>
          <Button onClick={() => playNote()}>Play</Button>
        </Col>
      </Row>
    </Container>
  );
}

export default App;
