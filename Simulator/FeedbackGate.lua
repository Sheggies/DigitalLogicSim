FeedbackGate = class(Gate)
FeedbackGate.feedbackSource = nil

function FeedbackGate:init(identifier, feedbackSource)
    Gate.init(self, identifier, BooleanOperationEnum.Feedback)
    self.feedbackSource = feedbackSource
    self.output = false
end

function FeedbackGate:simulate()
    self.output = BooleanOperation[self.booleanOperation](self.feedbackSource)
end

function FeedbackGate:toTable()
    return {
        identifier = self.identifier,
        booleanOperation = self.booleanOperation,
        feedbackSource = self.feedbackSource:getIdentifier()
    }
end
