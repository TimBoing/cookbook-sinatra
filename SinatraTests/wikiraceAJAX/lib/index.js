// TODO: write your code here!
// Update the counter
// Update the price displayed on the submit button
// Update the value of the read-only input (in cents)

const incrementers = document.querySelectorAll(".incrementer");
const counter = document.getElementById("counter");
const submitBtn = document.getElementById("submit");
const inputCents = document.getElementById("price-input");

const updateParticipants = (increment) => {
  counter.dataset.count = parseInt(counter.dataset.count, 10) + increment;
  counter.innerText = counter.dataset.count;
};

const updateBill = () => {
  submitBtn.value = `Pay ${parseInt(counter.dataset.count, 10) * 150}€`;
};

const updateCents = () => {
  inputCents.value = parseInt(counter.dataset.count, 10) * 15000;
};

incrementers.forEach((inc) => {
  inc.addEventListener(("click"), (event) => {
    const increment = parseInt(event.currentTarget.dataset.offset, 10);
    updateParticipants(increment);
    updateBill();
    updateCents();
  });
});
