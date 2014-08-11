require 'spec_helper'

describe Buff::ShellOut do
  describe "#shell_out" do
    let(:command) { "ls" }

    subject(:result) { described_class.shell_out(command) }

    it "returns a ShellOut::Response" do
      expect(result).to be_a(described_class::Response)
    end

    it "has a string for stdout" do
      expect(subject.stdout).to be_a(String)
    end

    it "has a string for stderr" do
      expect(subject.stderr).to be_a(String)
    end

    it "has a fixnum for exitstatus" do
      expect(subject.exitstatus).to be_a(Fixnum)
    end

    it "has a truth value for success?" do
      expect(subject.success?).to eql(true)
    end

    it "has a false value for error?" do
      expect(subject.error?).to eql(false)
    end

    context "when on MRI" do
      before { allow(described_class).to receive(:jruby?) { false } }

      it "delegates to #mri_out" do
        expect(described_class).to receive(:mri_out).with(command, {})
        result
      end

      context "when Process.waitpid2 returns an Integer instead of a Process::Status" do
        before { allow(Process).to receive(:waitpid2) { [12345, 0] } }

        it "sets the exitstatus to the returned integer" do
          expect(result.exitstatus).to eql(0)
        end
      end
    end

    context "when on JRuby" do
      before { allow(described_class).to receive(:jruby?) { true } }

      it "delegates to #jruby_out" do
        expect(described_class).to receive(:jruby_out).with(command, {})
        result
      end
    end
  end
end
