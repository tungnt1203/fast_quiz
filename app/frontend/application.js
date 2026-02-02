import { Application } from "@hotwired/stimulus"
import HelloController from "./controllers/hello_controller.js"
import ExamController from "./controllers/exam_controller.js"
import ExamResultController from "./controllers/exam_result_controller.js"

window.Stimulus = Application.start()
Stimulus.register("hello", HelloController)
Stimulus.register("exam", ExamController)
Stimulus.register("exam-result", ExamResultController)
