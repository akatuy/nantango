import React from "react";
import { useHistory } from "react-router";
import styled from "styled-components";
import { IQuestionAnswer } from "./LevelDetail";
const Sentence: React.FC<{
  QA: IQuestionAnswer;
}> = ({ QA }) => {
  return (
    <div className="sentence">
      <div className="word_en">{QA.en}</div>
      <div className="word_sound">{QA.meanings[0]}</div>
      <div className="word_ja">{QA.meanings[1]}</div>
    </div>
  );
};
const ResultPageWrapper = styled.div`
  padding: 5px;
  .success-message,
  #review {
    margin-top: 5px;
  }
`;
export default () => {
  const history = useHistory<{ wrongQAs: IQuestionAnswer[] }>();
  const QAs = history.location.state.wrongQAs;

  const now = new Date();
  return (
    <ResultPageWrapper>
      <div id="namae">
        <p>
          {`日時：${now.getFullYear()}年${now.getMonth() +
            1}月${now.getDate()}日`}
          　　名前：
          <input type="text" id="name" name="name" required />
        </p>
        <button onClick={window.print}>印刷する</button>
      </div>
      {QAs.length > 0 && (
        <div id="review">
          {QAs.map((QA, index) => (
            <Sentence key={index} QA={QA} />
          ))}
        </div>
      )}
      {QAs.length === 0 && (
        <h3 className="success-message">Congratulations, you are super!</h3>
      )}
    </ResultPageWrapper>
  );
};
