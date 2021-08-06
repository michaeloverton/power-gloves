import "./App.css";
import { useState } from "react";
import { Button, Row, Col, Container, Dropdown } from "react-bootstrap";

function App() {
  const [key, setKey] = useState("C");
  const [octaveCount, setOctaveCount] = useState(2);

  return (
    <Container className="App my-5 mx-5">
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
        <Col>Key: {key}</Col>
        <Col>Octaves: {octaveCount}</Col>
      </Row>

      <Row className="my-2">
        <Col>
          <Dropdown>
            <Dropdown.Toggle>Select Key</Dropdown.Toggle>

            <Dropdown.Menu>
              <Dropdown.Item onClick={() => setKey("C")}>C</Dropdown.Item>
              <Dropdown.Item onClick={() => setKey("C#")}>C#</Dropdown.Item>
              <Dropdown.Item onClick={() => setKey("D")}>D</Dropdown.Item>
            </Dropdown.Menu>
          </Dropdown>
        </Col>

        <Col>
          <Dropdown>
            <Dropdown.Toggle>Octave Count</Dropdown.Toggle>

            <Dropdown.Menu>
              <Dropdown.Item onClick={() => setOctaveCount(1)}>1</Dropdown.Item>
              <Dropdown.Item onClick={() => setOctaveCount(2)}>2</Dropdown.Item>
              <Dropdown.Item onClick={() => setOctaveCount(3)}>3</Dropdown.Item>
              <Dropdown.Item onClick={() => setOctaveCount(4)}>4</Dropdown.Item>
            </Dropdown.Menu>
          </Dropdown>
        </Col>
      </Row>
    </Container>
  );
}

export default App;
